//
//  DoctorChatViewController.swift
//  Maywave-iOS
//
//  Created by Codex on 5/6/26.
//

import SwiftUI
import AVFoundation

struct DoctorChatView: View {
    private enum EndingPage {
        case none
        case first
        case second
        case third
    }

    private enum DoctorStep {
        case narration(String)
        case chat(String, String)
        case my(String)
        case image(String, CGFloat, CGFloat)
        case record(String, CGFloat, CGFloat, [String])
        case firstChoices
        case treatmentChoices
    }

    private struct TimelineStep: Identifiable {
        let id = UUID()
        let content: DoctorStep
    }

    @Environment(\.dismiss) private var dismiss
    var onBackToRoleSelection: (() -> Void)? = nil
    @State private var steps: [TimelineStep] = []
    @State private var selectedFirstChoice: String?
    @State private var selectedTreatmentChoice: String?
    @State private var endingPage: EndingPage = .none
    @State private var scrollTrigger = 0
    @State private var showHistoryInfo = false
    @State private var presentedHistoryInfo: HistoryInfoData?
    @State private var readHistoryInfoIDs: Set<String> = []
    @State private var runningAudioPlayer: AVAudioPlayer?
    @State private var cryingAudioPlayer: AVAudioPlayer?
    @State private var heartAudioPlayer: AVAudioPlayer?

    private let stepDelay = 2.0

    private let firstChoices = [
        "환자에게 바로 달려간다",
        "병원으로 돌아가 대비한다"
    ]

    private let treatmentChoices = [
        "이 환자를 먼저 살린다",
        "다른 부상자들을 확인한다",
        "병원으로 이송을 요청한다"
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
                Text("의사")
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

    private var currentHistoryInfoIsAvailable: Bool {
        currentHistoryInfo.id != HistoryInfoData.resistanceStart.id
    }

    private var currentHistoryInfo: HistoryInfoData {
        let isTreatmentChoiceVisible = steps.contains { step in
            if case .treatmentChoices = step.content {
                return true
            }

            return false
        }

        for step in steps.reversed() {
            switch step.content {
            case .record(let imageName, _, _, _):
                if imageName == "doctor4" || imageName == "image 46" {
                    return .streetTreatmentStarted
                }

                if imageName == "doctor3" {
                    return .hospitalFull
                }

                if imageName == "doctor5" || imageName == "image 50" {
                    return .hospitalConfusion
                }

            case .image(let imageName, _, _):
                if imageName == "doctor1" && isTreatmentChoiceVisible {
                    return .streetTreatmentStarted
                }

                if imageName == "doctor2" {
                    return .hospitalFull
                }

            default:
                continue
            }
        }

        return .resistanceStart
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
                    .chat("동료", "전남대 쪽에서 다친 사람들이 나온대.\n응급환자 들어올 수도 있어."),
                    .narration("잠시 후, 부상자가 발생했다는 소식이 전해집니다."),
                    .my("어디야? 상태 어때?"),
                    .firstChoices
                ])
            }
        )
        .id("doctorIntro")
    }

    @ViewBuilder
    private func stepView(_ step: DoctorStep) -> some View {
        switch step {
        case .narration(let text):
            Text(text)
                .font(.custom("NanumMyeongjo", size: 13))
                .foregroundColor(Color("Narration"))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .transition(.opacity.combined(with: .move(edge: .bottom)))

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

        case .treatmentChoices:
            ChoicePromptView(
                title: "당신의 선택은?",
                choices: treatmentChoices,
                selectedChoice: selectedTreatmentChoice,
                onSelect: handleTreatmentChoice
            )
            .padding(.top, 26)
        }
    }

    private func handleFirstChoice(_ choice: String) {
        guard selectedFirstChoice == nil else { return }
        selectedFirstChoice = choice
        scrollTrigger += 1

        if choice == firstChoices[0] {
            playRunningSound()
            reveal(treatPatientSteps)
        } else {
            reveal(hospitalDirectSteps) {
                showEndingAfterDelay()
            }
        }
    }

    private func playRunningSound() {

        guard let url = Bundle.main.url(
            forResource: "Running",
            withExtension: "mp3"
        ) else {
            print("Running.mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {

            runningAudioPlayer = try AVAudioPlayer(contentsOf: url)
            runningAudioPlayer?.volume = 0.0
            runningAudioPlayer?.currentTime = 0.18
            runningAudioPlayer?.play()

            runningAudioPlayer?.setVolume(0.3, fadeDuration: 0.18)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                runningAudioPlayer?.setVolume(0.0, fadeDuration: 1.4)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.8) {
                runningAudioPlayer?.stop()
            }

        } catch {

            print(error)
        }
    }

    private func playCryingSound() {

        guard let url = Bundle.main.url(
            forResource: "crying",
            withExtension: "mp3"
        ) else {
            print("crying.mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {

            cryingAudioPlayer = try AVAudioPlayer(contentsOf: url)
            cryingAudioPlayer?.volume = 0.0
            cryingAudioPlayer?.currentTime = 0.3
            cryingAudioPlayer?.numberOfLoops = -1
            cryingAudioPlayer?.play()

            cryingAudioPlayer?.setVolume(0.08, fadeDuration: 1.0)

        } catch {

            print(error)
        }
    }

    private func stopCryingSound() {

        cryingAudioPlayer?.setVolume(0.0, fadeDuration: 2.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            cryingAudioPlayer?.stop()
            cryingAudioPlayer = nil
        }
    }

    private func playHeartSound() {

        guard let url = Bundle.main.url(
            forResource: "Heart",
            withExtension: "mp3"
        ) else {
            print("Heart.mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {

            heartAudioPlayer = try AVAudioPlayer(contentsOf: url)
            heartAudioPlayer?.volume = 0.0
            heartAudioPlayer?.currentTime = 0.42
            heartAudioPlayer?.numberOfLoops = -1
            heartAudioPlayer?.play()

            heartAudioPlayer?.setVolume(0.16, fadeDuration: 0.6)

        } catch {

            print(error)
        }
    }

    private func stopHeartSound() {

        heartAudioPlayer?.setVolume(0.0, fadeDuration: 1.6)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            heartAudioPlayer?.stop()
            heartAudioPlayer = nil
        }
    }

    private func handleTreatmentChoice(_ choice: String) {
        guard selectedTreatmentChoice == nil else { return }
        selectedTreatmentChoice = choice
        scrollTrigger += 1

        if choice == treatmentChoices[0] {
            reveal(saveOnePatientSteps) {
                showEndingAfterDelay()
            }
        } else if choice == treatmentChoices[1] {
            reveal(checkOtherPatientsSteps) {
                showEndingAfterDelay()
            }
        } else {
            reveal(transferPatientSteps) {
                showEndingAfterDelay()
            }
        }
    }

    private var treatPatientSteps: [DoctorStep] {
        [
            .narration("당신은 망설일 틈 없이 움직였습니다."),
            .narration("그날, 많은 의료진이"),
            .narration("위험 속에서도 부상자들에게 달려갔습니다."),
            .my("환자 어디 있어?"),
            .narration("당신은 사람들을 밀치듯 앞으로 나아갑니다."),
            .chat("주변 시민", "여기요! 여기 좀 봐주세요!"),
            .narration("쓰러진 사람이 보입니다."),
            .image("doctor1", 345, 259),
            .narration("손이 멈칫합니다."),
            .my("잠깐만..."),
            .my("이 상처..."),
            .my("...총상이야"),
            .my("이건... 사고가 아니야."),
            .narration("순간, 상황이 다르게 보이기 시작합니다."),
            .chat("주변 시민", "살릴 수 있죠...?"),
            .narration("환자를 살피던 순간,"),
            .narration("다른 곳에서도 도움을 요청하는 소리가 들립니다."),
            .my("..."),
            .my("환자가... 한 명이 아니야."),
            .treatmentChoices
        ]
    }

    private var saveOnePatientSteps: [DoctorStep] {
        [
            .my("지금 이 사람부터 볼게요"),
            .narration("당신은 눈앞의 환자에게 집중합니다."),
            .my("의식 있어요?"),
            .chat("주변 시민", "제발 도와드릴까요?!"),
            .my("여기 눌러주세요! 계속!"),
            .narration("주변에서 계속 소리가 들립니다."),
            .chat("주변 시민", "여기도 다쳤어요!"),
            .chat("주변 시민", "이쪽도 좀 봐주세요!"),
            .narration("다른 환자들이 보이지만,"),
            .narration("지금은 이 사람을 놓을 수 없습니다."),
            .narration("출혈이 쉽게 멈추지 않습니다."),
            .my("...이송해야 해."),
            .narration("당신은 한 사람에게 집중했습니다."),
            .narration("그날, 많은 의료진이"),
            .narration("눈앞의 생명을 살리기 위해"),
            .narration("다른 선택을 뒤로 미뤄야 했습니다."),
            .record(
                "image 46",
                368,
                238,
                [
                    "계엄군의 강경 진압으로 광주 시내 곳곳에서 부상자가 발생했습니다.",
                    "당시 전남대병원과 광주기독병원 의료진들은 부족한 의료 물품 속에서도",
                    "시민들을 치료해야 했으며, 의대생과 간호사들 또한 구조 활동에 참여했습니다.",
                    "병원으로 이송되지 못한 부상자들은 거리에서 응급 처치를 받기도 했습니다."
                ]
            )
        ]
    }

    private var checkOtherPatientsSteps: [DoctorStep] {
        [
            .narration("당신은 주변의 다른 부상자들을 확인했습니다."),
            .narration("하지만 상황은"),
            .narration("한 사람만의 문제가 아니었습니다."),
            .narration("그날 현장에서는"),
            .narration("여러 부상자들이 동시에 발생했고,"),
            .narration("의료진은"),
            .narration("누구를 먼저 치료해야 할지"),
            .narration("결정해야 하는 상황에 놓였습니다."),
            .my("잠깐만... 주변부터 봐야 해."),
            .narration("당신은 환자에게서 시선을 떼고"),
            .narration("주변을 살핍니다."),
            .narration("여러 명이 쓰러져 있습니다."),
            .narration("곳곳에서 도움을 요청하는 소리가 들립니다."),
            .chat("주변 시민", "여기도요! 여기 좀 봐주세요!"),
            .chat("주변 시민", "피가 너무 많이 나요!"),
            .chat("주변 시민", "살려주세요..."),
            .my("한 명씩 볼 수 있는 상황이 아니야."),
            .narration("환자 수가 계속 늘어나고 있습니다."),
            .narration("당신 혼자 감당할 수 있는 수준이 아닙니다."),
            .record(
                "image 50",
                282,
                405,
                [
                    "광주에서는",
                    "많은 부상자들이 발생했고,",
                    "의료 현장은",
                    "그 상황을 감당하기 어려웠습니다."
                ]
            )
        ]
    }

    private var transferPatientSteps: [DoctorStep] {

        let steps: [DoctorStep] = [
            .narration("당신은 환자를 병원으로 옮기려 했습니다."),
            .narration("하지만 병원 역시"),
            .narration("이미 한계를 넘은 상태였습니다."),
            .my("이송해야 해. 들것 있어요?"),
            .chat("주변 시민", "차로 옮겨야 해요!"),
            .narration("당신은 환자를 옮기기 시작합니다."),
            .narration("몇몇 시민들이 함께 환자를 들어 올립니다."),
            .narration("급히 차량으로 향합니다."),
            .image("doctor2", 335, 251),
            .narration("병원에 도착했을 때,"),
            .narration("이미 분위기가 심상치 않습니다.")
        ]

        return steps + hospitalOverloadSteps
    }

    private var hospitalDirectSteps: [DoctorStep] {
        [
            .image("doctor2", 335, 251),
            .narration("병원에 도착했을 때,"),
            .narration("이미 분위기가 심상치 않습니다.")
        ] + hospitalOverloadSteps
    }

    private var hospitalOverloadSteps: [DoctorStep] {
        [
            .chat("동료", "환자 들어오기 시작했어!"),
            .chat("동료", "곧 더 올 거야!"),
            .narration("환자들이 하나둘 들어오기 시작합니다."),
            .narration("잠시 후,"),
            .narration("환자가 급격히 늘어나기 시작합니다."),
            .chat("주변", "여기 자리 없어요!"),
            .chat("주변", "장비 부족해요!"),
            .chat("주변", "다 볼 수가 없어요!"),
            .my("..."),
            .my("감당이 안 돼..."),
            .narration("환자 수가 계속 늘어나고 있습니다."),
            .narration("모든 환자를 치료하는 것은 불가능합니다."),
            .record(
                "doctor3",
                335,
                251,
                [
                    "당시 병원에는",
                    "많은 부상자들이 몰려들었고,",
                    "의료 인력과 장비는",
                    "그 수요를 감당하기 어려웠습니다."
                ]
            )
        ]
    }

    private func reveal(_ newSteps: [DoctorStep], completion: (() -> Void)? = nil) {
        var accumulatedDelay = 0.0

        for (index, step) in newSteps.enumerated() {
            accumulatedDelay += stepDelay

            if case .record = step {
                accumulatedDelay += 2.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + accumulatedDelay) {

                if case .chat(_, let message) = step {

                    if message == "여기요! 여기 좀 봐주세요!" {
                        playCryingSound()
                    }

                    if message == "살릴 수 있죠...?" {
                        stopCryingSound()
                    }
                }

                if case .my(let text) = step {

                    if text == "여기 눌러주세요! 계속!" {
                        playHeartSound()
                    }

                    if text == "...이송해야 해." {
                        stopHeartSound()
                    }
                }

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
                            "누군가는 한 사람에게 집중했고,",
                            "누군가는 더 많은 사람을 살피려 했으며,",
                            "누군가는 이송을 선택했습니다.",
                            "하지만 어떤 선택이든,",
                            "모두를 동시에 살릴 수 없는 상황 속에서",
                            "내려진 결정이었습니다.",
                            "그날의 판단은",
                            "지금까지 기억되고 있습니다."
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
                            "당신은 그날의 의료진이었습니다."
                        ]
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.45)) {
                            endingPage = .third
                        }
                    }
                }

                if endingPage == .third {
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
        if let onBackToRoleSelection {
            onBackToRoleSelection()
        } else {
            dismiss()
        }
    }
}

#Preview {
    DoctorChatView()
}
