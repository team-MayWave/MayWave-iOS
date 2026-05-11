//
//  CitizenChatViewController.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/5/26.
//

import SwiftUI

struct CitizenChatView: View {
    private enum EndingPage {
        case none
        case first
        case second
    }

    private enum CitizenStep {
        case narration(String)
        case chat(String, String)
        case my(String)
        case image(String, CGFloat, CGFloat)
        case record(String, CGFloat, CGFloat, [String])
        case firstChoices
        case fallenChoices
    }

    private struct TimelineStep: Identifiable {
        let id = UUID()
        let content: CitizenStep
    }

    @Environment(\.dismiss) private var dismiss
    var onBackToRoleSelection: (() -> Void)? = nil
    @State private var steps: [TimelineStep] = []
    @State private var selectedFirstChoice: String?
    @State private var selectedFallenChoice: String?
    @State private var endingPage: EndingPage = .none
    @State private var scrollTrigger = 0
    @State private var showHistoryInfo = false
    @State private var presentedHistoryInfo: HistoryInfoData?
    @State private var readHistoryInfoIDs: Set<String> = []

    private let stepDelay = 2.0

    private let firstChoices = [
        "가까이 가서 본다",
        "멀리서 지켜 본다"
    ]

    private let fallenChoices = [
        "쓰러진 사람에게 다가간다",
        "뒤로 물러나 상황을 피한다"
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
                    showsBadge: endingPage == .none
                )
            }

            VStack(spacing: 4) {
                Text("시민")
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

    private var currentHistoryInfoHasRead: Binding<Bool> {
        Binding(
            get: {
                readHistoryInfoIDs.contains(currentHistoryInfo.id)
            },
            set: { hasRead in
                if hasRead {
                    readHistoryInfoIDs.insert(currentHistoryInfo.id)
                } else {
                    readHistoryInfoIDs.remove(currentHistoryInfo.id)
                }
            }
        )
    }

    private var currentHistoryInfo: HistoryInfoData {
        for step in steps.reversed() {
            switch step.content {
            case .record(let imageName, _, _, _):
                if imageName == "image 43" || imageName == "image 44" {
                    return .geumnamroMarch
                }

                if imageName == "image 40" {
                    return .martialControl
                }

            case .image(let imageName, _, _):
                if imageName == "twoscene" {
                    return .citizensOnStreet
                }

                if imageName == "fourscene" {
                    return .martialControl
                }

                if imageName == "fivescene" {
                    return .geumnamroMarch
                }

            default:
                continue
            }
        }

        return .resistanceStart
    }

    private func recordDate(for imageName: String) -> String {
        if imageName == "image 44" {
            return "1980년 5월 18일"
        }

        return "1980년 5월 19일"
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
                reveal([
                    .chat("친구", "전남대 쪽에서 학생들이 막혔다더라.\n계엄군이 들어왔대."),
                    .my("무슨 일인데?"),
                    .narration("잠시 후, 군인들이 시내로 이동합니다."),
                    .firstChoices
                ])
            }
        )
        .id("citizenIntro")
    }

    @ViewBuilder
    private func stepView(_ step: CitizenStep) -> some View {
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
                dateText: recordDate(for: imageName),
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

        case .fallenChoices:
            ChoicePromptView(
                title: "당신의 선택은?",
                choices: fallenChoices,
                selectedChoice: selectedFallenChoice,
                onSelect: handleFallenChoice
            )
            .padding(.top, 26)
        }
    }

    private func handleFirstChoice(_ choice: String) {
        guard selectedFirstChoice == nil else { return }
        selectedFirstChoice = choice
        scrollTrigger += 1

        if choice == firstChoices[0] {
            reveal(approachSteps)
        } else {
            reveal(watchSteps) {
                showEndingAfterDelay()
            }
        }
    }

    private func handleFallenChoice(_ choice: String) {
        guard selectedFallenChoice == nil else { return }
        selectedFallenChoice = choice
        scrollTrigger += 1

        if choice == fallenChoices[0] {
            reveal(helpFallenSteps) {
                showEndingAfterDelay()
            }
        } else {
            reveal(avoidFallenSteps) {
                showEndingAfterDelay()
            }
        }
    }

    private var approachSteps: [CitizenStep] {
        [
            .narration("당신은 불안함 속에서도 발걸음을 옮겼습니다."),
            .narration("당시에도 많은 시민들이"),
            .narration("무슨 일이 일어나고 있는지 직접 확인하려 했습니다."),
            .my("뭔가 이상한데...\n가까이 가서 확인해볼게."),
            .narration("사람들 사이를 지나 더 가까이 다가갑니다."),
            .chat("주변 시민", "왜 저렇게까지 서 있는 거야..."),
            .narration("군인들이 줄을 서 있습니다."),
            .chat("친구", "야.. 분위기 이상한데"),
            .my("....."),
            .image("twoscene", 357, 268),
            .narration("순간, 군인들이 움직이기 시작합니다."),
            .chat("주변 시민", "뒤로 가! 위험해!"),
            .narration("사람들이 뒤로 밀려납니다."),
            .chat("주변 시민", "일으켜! 괜찮아?!"),
            .my("....."),
            .narration("넘어지는 사람이 보입니다."),
            .fallenChoices
        ]
    }

    private var helpFallenSteps: [CitizenStep] {
        [
            .narration("당신은 망설임 속에서도 발걸음을 옮겼습니다."),
            .narration("그날, 많은 시민들이"),
            .narration("서로를 지키기 위해 손을 내밀었습니다."),
            .my("괜찮아요?"),
            .image("fourscene", 369, 246),
            .narration("혼란 속에서 사람들이 움직이기 시작합니다."),
            .chat("주변 시민", "여기 좀 봐줘!"),
            .narration("당신은 그 자리에 서 있었습니다."),
            .narration("아직 상황을 완전히 이해하지 못한 채,"),
            .narration("그저 바라보고 있습니다."),
            .narration("그날의 일은,"),
            .narration("단순한 충돌로 끝나지 않았습니다."),
            .record(
                "image 40",
                348,
                244,
                [
                    "사진 속 인물은 훗날 시민군 상황실장을",
                    "맡게 되는 박남선의 동생, 박남규입니다.",
                    "당시 금남로 일대에서는 공수부대의 강경 진압이 이어지고 있었으며,",
                    "박남규는 가톨릭센터 인근에서 공수부대원에게 폭행당했습니다.",
                    "이러한 진압 장면들은 시민들에게 빠르게 알려졌고,",
                    "분노한 시민들이 거리로 모여들기 시작했습니다.",
                    "이후 시위는 학생 중심에서",
                    "시민 전체로 확산되며 광주 전역으로 퍼져나갔습니다.",
                    "당신은 그 시작을 목격했습니다."
                ]
            )
        ]
    }

    private var avoidFallenSteps: [CitizenStep] {
        [
            .narration("당신은 선뜻 움직이지 못했습니다."),
            .narration("눈앞의 상황은 낯설고,"),
            .narration("어디까지 다가가야 할지 알 수 없었습니다."),
            .narration("그날, 많은 시민들이"),
            .narration("같은 자리에서 상황을 바라보고 있었습니다."),
            .my("여기서 더 가면 위험할 것 같아."),
            .narration("당신은 한 발짝 뒤로 물러납니다."),
            .narration("사람들 사이에 가려 앞쪽이 잘 보이지 않습니다."),
            .chat("주변 시민", "일으켜! 괜찮아?!"),
            .narration("누군가를 부르는 소리가 들립니다."),
            .narration("하지만, 정확히 보이지는 않습니다."),
            .image("fivescene", 338, 226),
            .narration("당신은 그 자리에 서서,"),
            .narration("상황을 바라보고 있습니다."),
            .record(
                "image 43",
                348,
                246,
                [
                    "계엄군의 진압이 계속되자 더 많은 시민들이 금남로로 모여들기 시작했습니다.",
                    "당시 시민군으로 알려진 ‘김군’과 같은 평범한 시민들도",
                    "거리에서 시위대와 부상자들을 돕고 있었습니다.",
                    "학생들의 시위는 시민 전체의 저항으로 확산되고 있었습니다.",
                    "당신은 그날의 광주를 바라보고 있었습니다."
                ]
            )
        ]
    }

    private var watchSteps: [CitizenStep] {
        [
            .narration("당신은 선뜻 움직이지 못했습니다."),
            .narration("눈앞의 상황은 낯설고,"),
            .narration("어디까지 다가가야 할지 알 수 없었습니다."),
            .narration("그날, 많은 시민들이"),
            .narration("같은 자리에서 상황을 지켜보고 있었습니다."),
            .my("뭔가 이상한데...\n지금은 좀 떨어져서 보자."),
            .narration("사람들 사이에 섞이지 않고, 뒤에서 상황을 바라봅니다."),
            .narration("앞쪽에서 갑자기 사람들이 크게 움직이기 시작합니다."),
            .chat("주변 시민", "뒤로 가 위험해!"),
            .narration("무슨 일이 일어나고 있는지"),
            .narration("정확히 보이지 않습니다."),
            .narration("당신은 그 자리에 서서,"),
            .narration("그저 상황을 바라보고 있습니다."),
            .record(
                "image 44",
                348,
                435,
                [
                    "계엄군의 강경 진압이 이어지면서 광주 시내에는",
                    "더 많은 시민들이 모여들기 시작했습니다.",
                    "당시 시민군 대변인을 맡게 되는 윤상원 역시 시민들과",
                    "함께 광주의 상황을 알리며 민주화를 요구하고 있었습니다.",
                    "시민들의 증언과 현장의 소식은 빠르게 퍼져나갔고,",
                    "학생 중심이던 시위는 시민 전체의 저항으로 확산되었습니다.",
                    "당신은 그날의 광주를 지켜본 시민 중 한 사람이었습니다."
                ]
            )
        ]
    }

    private func reveal(_ newSteps: [CitizenStep], completion: (() -> Void)? = nil) {
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
                            "많은 시민들이 거리로 나섰고,",
                            "또 다른 이들은",
                            "그 자리에 서서 상황을 지켜봤습니다.",
                            "각자의 선택은 달랐지만,",
                            "모두가 같은 시간을 지나고 있었습니다.",
                            "당신은,",
                            "그날의 한 사람이었습니다."
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
    CitizenChatView()
}
