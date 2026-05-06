//
//  ChoicePromptView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

struct ChoicePromptView: View {
    let title: String
    let choices: [String]
    var selectedChoice: String? = nil
    var onSelect: (String) -> Void = { _ in }
    @State private var isVisible = false

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
                        onSelect(choice)
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
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
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
