//
//  ChoicePromptView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI
import AVFoundation

struct ChoicePromptView: View {
    let title: String
    let choices: [String]
    var selectedChoice: String? = nil
    var onSelect: (String) -> Void = { _ in }
    @State private var isVisible = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 35) {
                Image("LRectangle")
                    .resizable()
                    .frame(width: 112, height: 1)

                Text(title)
                    .font(.custom("NanumMyeongjo", size: 12))
                    .foregroundColor(Color("detail"))

                Image("RRectangle")
                    .resizable()
                    .frame(width: 112, height: 1)
            }

            VStack(spacing: 12) {
                ForEach(choices, id: \.self) { choice in
                    Button {
                        guard selectedChoice == nil else { return }

                        playClickSound()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                            onSelect(choice)
                        }
                    } label: {
                        Text(choice)
                            .font(.custom("NanumMyeongjo", size: 13))
                            .foregroundColor(choiceTextColor(for: choice))
                            .frame(maxWidth: .infinity)
                            .frame(height: 39)
                            .background(
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(choiceFillColor(for: choice))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(choiceStrokeColor(for: choice), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 43)
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .onAppear {

            playChoiceAppearSound()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                withAnimation(.easeOut(duration: 0.4)) {
                    isVisible = true
                }
            }
        }
    }

    private func playChoiceAppearSound() {

        guard let url = Bundle.main.url(
            forResource: "choice",
            withExtension: "mp3"
        ) else {
            print("choice.mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.currentTime = 0.18
            audioPlayer?.volume = 0.35
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }

    private func playClickSound() {

        guard let url = Bundle.main.url(
            forResource: "clik",
            withExtension: "mp3"
        ) else {
            print("clik.mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let clickPlayer = try AVAudioPlayer(contentsOf: url)
            clickPlayer.currentTime = 0.08
            clickPlayer.volume = 0.55
            clickPlayer.play()
            self.audioPlayer = clickPlayer
        } catch {
            print(error)
        }
    }

    private func choiceFillColor(for choice: String) -> Color {
        if selectedChoice == nil || selectedChoice == choice {
            return Color.gray.opacity(0.25)
        }

        return Color.black.opacity(0.25)
    }

    private func choiceStrokeColor(for choice: String) -> Color {
        if selectedChoice == nil || selectedChoice == choice {
            return Color.white.opacity(0.35)
        }

        return Color.white.opacity(0.12)
    }

    private func choiceTextColor(for choice: String) -> Color {
        if selectedChoice == nil || selectedChoice == choice {
            return .white
        }

        return Color.white.opacity(0.22)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ChoicePromptView(
            title: "당신의 선택은?",
            choices: ["가까이 가서 본다", "멀리서 지켜 본다"]
        )
    }
}
