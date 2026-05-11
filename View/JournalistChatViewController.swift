//
//  JournalistChatViewController.swift
//  Maywave-iOS
//
//  Created by Codex on 5/6/26.
//

import SwiftUI

struct JournalistChatView: View {
    private enum EndingPage {
        case none
        case first
        case second
    }

    private enum JournalistStep {
        case narration(String)
        case chat(String, String)
        case my(String)
        case image(String, CGFloat, CGFloat)
        case record(String, CGFloat, CGFloat, [String])
        case firstChoices
    }

    private struct TimelineStep: Identifiable {
        let id = UUID()
        let content: JournalistStep
    }

    @Environment(\.dismiss) private var dismiss
    var onBackToRoleSelection: (() -> Void)? = nil
    @State private var steps: [TimelineStep] = []
    @State private var selectedFirstChoice: String?
    @State private var endingPage: EndingPage = .none
    @State private var scrollTrigger = 0
    @State private var showHistoryInfo = false
    @State private var presentedHistoryInfo: HistoryInfoData?
    @State private var readHistoryInfoIDs: Set<String> = []

    private let stepDelay = 2.0

    private let firstChoices = [
        "계속 촬영한다",
        "도망친다"
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if endingPage == .none {
                VStack(spacing: 0) {
                    header

                    Rectangle()
                        .fill(Color("Narration"))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 22) {
                                intro

                                ForEach(steps) { step in
                                    stepView(step.content)
                                }

                                Color.clear
                                    .frame(height: 1)
                                    .id("bottom")
                            }
                            .padding(.bottom, 40)
                        }
                        .onChange(of: scrollTrigger) { _, _ in
                            scrollToBottom(proxy)
                        }
                    }
                }
            } else {
                endingContent
            }

            if showHistoryInfo {
                let info = presentedHistoryInfo ?? currentHistoryInfo

                HistoryInfoOverlay(info: info) {
                    readHistoryInfoIDs.insert(info.id)
                    withAnimation(.easeOut(duration: 0.25)) {
                        showHistoryInfo = false
                    }
                }
            }
        }
        .onChange(of: showHistoryInfo) { _, isPresented in
            if isPresented {
                presentedHistoryInfo = currentHistoryInfo
            } else {
                presentedHistoryInfo = nil
            }
        }
    }

    private var header: some View {
        ZStack {
            HStack {
                Button {
                    goBackToRoleSelection()
                } label: {
                    Image("Arrow")
                        .frame(width: 44, height: 44, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Spacer()

                HistoryInfoButton(
                    isPresented: $showHistoryInfo,
                    hasRead: currentHistoryInfoHasRead,
                    showsBadge: currentHistoryInfoIsAvailable && endingPage == .none
                )
            }

            VStack(spacing: 4) {
                Text("기자")
                    .font(.custom("NanumMyeongjoExtraBold", size: 25))
                    .foregroundColor(.white)

                Text("1980년 5월 18일, 광주")
                    .font(.custom("NanumMyeongjo", size: 15))
                    .foregroundColor(Color("Narration"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var intro: some View {
        IntroSceneView(
            data: IntroSceneData(
                dateText: "5월 18일",
                locationText: "광주, 금남로",
                imageName: "Basicscene",
                messages: [
                    "시내 분위기가 심상치 않습니다",
                    "사람들이 모여들기 시작합니다"
                ]
            ),
            onFinished: {
                guard steps.isEmpty else { return }
                reveal(baseSteps)
            }
        )
        .id("journalistIntro")
    }

    private var currentHistoryInfo: HistoryInfoData {
        currentHistoryInfoIsAvailable ? .journalistCrackdownStarted : .resistanceStart
    }

    private var currentHistoryInfoIsAvailable: Bool {
        guard endingPage == .none, selectedFirstChoice == nil else { return false }

        return steps.contains { step in
            switch step.content {
            case .image(let name, _, _):
                return name == "editer1"
            case .firstChoices:
                return true
            default:
                return false
            }
        }
    }

    private var currentHistoryInfoHasRead: Binding<Bool> {
        Binding(
            get: {
                readHistoryInfoIDs.contains(currentHistoryInfo.id)
            },
            set: { isRead in
                if isRead {
                    readHistoryInfoIDs.insert(currentHistoryInfo.id)
                } else {
                    readHistoryInfoIDs.remove(currentHistoryInfo.id)
                }
            }
        )
    }

    @ViewBuilder
    private func stepView(_ step: JournalistStep) -> some View {
        switch step {
        case .narration(let text):
            Text(text)
                .font(.custom("NanumMyeongjo", size: 13))
                .foregroundColor(Color("Narration"))
                .multilineTextAlignment(.center)
                .padding(.top, 10)

        case .chat(let name, let message):
            ChatBubbleView(name: name, message: message)

        case .my(let message):
            MyChatBubbleView(name: "나", message: message)

        case .image(let name, let width, let height):
            StoryImageView(imageName: name, width: width, height: height)
                .padding(.top, 12)

        case .record(let imageName, let width, let height, let lines):
            RecordSceneView(
                imageName: imageName,
                imageWidth: width,
                imageHeight: height,
                lines: lines
            )
            .padding(.top, 34)

        case .firstChoices:
            ChoicePromptView(
                title: "당신의 선택은?",
                choices: firstChoices,
                selectedChoice: selectedFirstChoice,
                onSelect: handleFirstChoice
            )
            .padding(.top, 26)
        }
    }

    private func handleFirstChoice(_ choice: String) {
        guard selectedFirstChoice == nil else { return }
        selectedFirstChoice = choice
        scrollTrigger += 1

        if choice == firstChoices[0] {
            reveal(keepRecordingSteps) {
                showEndingAfterDelay()
            }
        } else {
            reveal(escapeSteps) {
                showEndingAfterDelay()
            }
        }
    }

    private var baseSteps: [JournalistStep] {
        [
            .narration("당신은 소식을 듣고 현장에 도착했습니다."),
            .narration("이미 혼란이 번진 상황입니다."),
            .my("....."),
            .narration("사람들이 모여 있고,"),
            .narration("곳곳에서 혼란이 이어지고 있습니다."),
            .chat("주변 시민", "다쳤어요 여기 좀 봐주세요!"),
            .my("....."),
            .my("카메라... 켜"),
            .narration("당신은 상황을 기록하기 시작합니다."),
            .narration("렌즈에 모든 장면이 떨리며 담깁니다."),
            .image("editer1", 345, 259),
            .narration("군인들과 시민들이"),
            .narration("뒤엉켜 있습니다."),
            .narration("부상자들이 계속 발생하고 있습니다."),
            .my("이건..."),
            .my("남겨야 돼..."),
            .narration("당신이 카메라를 들고 있는 순간,"),
            .narration("한 군인이 당신을 바라봅니다."),
            .narration("시선이 마주칩니다."),
            .my("..."),
            .firstChoices
        ]
    }

    private var keepRecordingSteps: [JournalistStep] {
        [
            .narration("당신은 위험 속에서도 기록을 선택했습니다."),
            .narration("그날의 많은 장면들은"),
            .narration("이러한 기록을 통해"),
            .narration("세상에 알려지게 되었습니다."),
            .my("지금 멈출 수 없어"),
            .narration("당신은 카메라를 내려놓지 않습니다."),
            .chat("군인", "야 뭐 찍어"),
            .narration("위험한 순간까지 가까워집니다."),
            .narration("군인이 점점 앞으로 다가옵니다."),
            .chat("군인", "카메라 내려!"),
            .my("...."),
            .narration("당신은 끝까지 카메라를 놓지 않습니다."),
            .narration("그 순간까지 기록합니다."),
            .narration("..."),
            .record(
                "image 35",
                345,
                259,
                [
                    "독일 기자 힌츠페터 는 광주에 잠입해 시민들과 계엄군의 충돌 현장을",
                    "카메라에 기록했습니다.",
                    "",
                    "그는 금남로와 전남도청 일대에서 촬영한 영상과 사진들을 해외로 전달했고,",
                    "이는 이후 광주의 상황이 세계에 알려지는 중요한 계기가 되었습니다."
                ]
            )
        ]
    }

    private var escapeSteps: [JournalistStep] {
        [
            .narration("당신은 안전을 선택했습니다."),
            .narration("하지만 그날의 모든 장면이"),
            .narration("기록으로 남을 수는 없었습니다."),
            .narration("당신은 몸을 돌리지 않습니다."),
            .narration("카메라는 내려간 채입니다."),
            .my("..."),
            .record(
                "editer2",
                345,
                259,
                [
                    "광주에서는",
                    "많은 사건들이 발생했지만,",
                    "모든 순간이 기록되지는 않았습니다."
                ]
            )
        ]
    }

    private func reveal(_ newSteps: [JournalistStep], completion: (() -> Void)? = nil) {
        var accumulatedDelay = 0.0

        for (index, step) in newSteps.enumerated() {
            accumulatedDelay += stepDelay

            if case .record = step {
                accumulatedDelay += 2.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + accumulatedDelay) {
                steps.append(TimelineStep(content: step))
                scrollTrigger += 1

                if index == newSteps.count - 1 {
                    if case .record(_, _, _, let lines) = step {
                        DispatchQueue.main.asyncAfter(deadline: .now() + recordTypingDuration(for: lines)) {
                            completion?()
                        }
                    } else {
                        completion?()
                    }
                }
            }
        }
    }

    private func recordTypingDuration(for lines: [String]) -> Double {
        let characterCount = lines.reduce(0) { $0 + $1.count }
        let typingDuration = Double(characterCount) * 0.07
        let linePauseDuration = Double(lines.count) * 0.55
        return typingDuration + linePauseDuration + 0.8
    }

    private func showEndingAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay * 2) {
            withAnimation(.easeOut(duration: 0.55)) {
                endingPage = .first
            }
        }
    }

    private var endingContent: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if endingPage == .first {
                    EndingTextView(
                        lines: [
                            "그날,",
                            "어떤 장면은 기록으로 남았고,",
                            "어떤 장면은 남지 못했습니다.",
                            "하지만 기록된 것과",
                            "기록되지 못한 것 모두,",
                            "그날의 일부였습니다.",
                            "그날의 진실은",
                            "그렇게 이어지고 있습니다."
                        ]
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.45)) {
                            endingPage = .second
                        }
                    }
                }

                if endingPage == .second {
                    EndingTextView(
                        lines: [
                            "그날의 시간은 끝났지만,",
                            "그날의 이야기는",
                            "아직 끝나지 않았습니다.",
                            "우리는,",
                            "그날을 기억합니다."
                        ],
                        showDate: true
                    )
                    .contentShape(Rectangle())
                }
            }

            Button {
                goBackToRoleSelection()
            } label: {
                Image("Arrow")
                    .frame(width: 44, height: 44, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.top, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.65)) {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }

    private func goBackToRoleSelection() {
        onBackToRoleSelection?()
        dismiss()
    }
}

#Preview {
    JournalistChatView()
}
