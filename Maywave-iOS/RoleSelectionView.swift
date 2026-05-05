//
//  RoleSelectionView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

private struct Role: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let imageSize: CGSize
    let imageTopOffset: CGFloat
}

struct RoleSelectionView: View {
    @State private var selectedIndex = 0
    private let figmaSize = CGSize(width: 401, height: 866)

    private let roles = [
        Role(
            title: "시민",
            subtitle: "그날, 평범한 시민이었습니다.\n그리고, 역사의 한가운데 있었습니다.",
            imageName: "citizen",
            imageSize: CGSize(width: 386, height: 580),
            imageTopOffset: 45
        ),
        Role(
            title: "의사",
            subtitle: "그날, 환자들이 몰려왔습니다.\n그리고, 멈출 수 없었습니다.",
            imageName: "doctor",
            imageSize: CGSize(width: 426, height: 499),
            imageTopOffset: 45
        ),
        Role(
            title: "기자",
            subtitle: "그날, 진실은 쉽게 보이지 않았습니다.\n당신은 그것을 기록하려 합니다.",
            imageName: "editor",
            imageSize: CGSize(width: 418, height: 510),
            imageTopOffset: 45
        )
    ]

    private var selectedRole: Role {
        roles[selectedIndex]
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.ignoresSafeArea()

                figmaFrame
                    .frame(width: figmaSize.width, height: figmaSize.height)
                    .scaleEffect(scale(for: proxy.size))
            }
            .ignoresSafeArea()
        }
    }

    private var figmaFrame: some View {
        ZStack {
            Image("background")
                .resizable()
                .frame(width: figmaSize.width, height: figmaSize.height)

            Image(selectedRole.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: selectedRole.imageSize.width,
                    height: selectedRole.imageSize.height
                )
                .position(
                    x: figmaSize.width / 2,
                    y: selectedRole.imageTopOffset + selectedRole.imageSize.height / 2
                )
                .id(selectedRole.imageName)
                .transition(.opacity)

            arrowButton(systemName: "chevron.left") {
                moveSelection(by: -1)
            }
            .position(x: 32, y: 401)

            arrowButton(systemName: "chevron.right") {
                moveSelection(by: 1)
            }
            .position(x: 369, y: 401)

            roleText
                .position(x: figmaSize.width / 2, y: 662)

            Button {
                // 다음 화면 연결 지점
            } label: {
                Text("선택하기")
                    .font(.system(size: 22, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.95), radius: 10)
                    .frame(width: 150, height: 48)
            }
            .buttonStyle(.plain)
            .position(x: figmaSize.width / 2, y: 780)
        }
        .frame(width: figmaSize.width, height: figmaSize.height)
        .clipped()
        .animation(.easeInOut(duration: 0.28), value: selectedIndex)
    }

    private var roleText: some View {
        VStack(spacing: 15) {
            Text(selectedRole.title)
                .font(.system(size: 32, design: .serif))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.65), radius: 6, y: 2)

            Image("Frame 1")
                .resizable()
                .scaledToFit()
                .frame(width: 93, height: 4.25)
                .padding(.bottom, 17)

            Text(selectedRole.subtitle)
                .font(.system(size: 15, design: .serif))
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))
        }
    }

    private func scale(for size: CGSize) -> CGFloat {
        size.width / figmaSize.width
    }

    private func arrowButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .light))
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemName == "chevron.left" ? "이전 역할" : "다음 역할")
    }

    private func moveSelection(by offset: Int) {
        selectedIndex = (selectedIndex + offset + roles.count) % roles.count
    }
}

#Preview {
    RoleSelectionView()
}
