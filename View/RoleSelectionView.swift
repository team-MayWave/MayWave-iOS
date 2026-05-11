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
    let imageContentOffsetY: CGFloat
}

private struct ActiveRole: Identifiable {
    let id: String
}

struct RoleSelectionView: View {
    @State private var selectedIndex = 0
    @State private var activeRole: ActiveRole?
    private let figmaSize = CGSize(width: 401, height: 866)
    private let roleImageSize = CGSize(width: 418, height: 510)
    private let roleImageTopOffset: CGFloat = 45

    private let roles = [
        Role(
            title: "시민",
            subtitle: "그날, 평범한 시민이었습니다.\n그리고, 역사의 한가운데 있었습니다.",
            imageName: "citizen",
            imageContentOffsetY: 0
        ),
        Role(
            title: "의사",
            subtitle: "그날, 환자들이 몰려왔습니다.\n그리고, 멈출 수 없었습니다.",
            imageName: "doctor",
            imageContentOffsetY: -11
        ),
        Role(
            title: "기자",
            subtitle: "그날, 진실은 쉽게 보이지 않았습니다.\n당신은 그것을 기록하려 합니다.",
            imageName: "editor",
            imageContentOffsetY: 0
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
        .onAppear {
            GameAPI.playGame(roleId: 2, scenarioId: 1, choice: 1)
        }
    }

    private var figmaFrame: some View {
        ZStack {
            Image("background")
                .resizable()
                .frame(width: figmaSize.width, height: figmaSize.height)

            roleImage
                .position(
                    x: figmaSize.width / 2,
                    y: roleImageTopOffset + roleImageSize.height / 2
                )

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
                activeRole = ActiveRole(id: selectedRole.title)
            } label: {
                Text("선택하기")
                    .font(.custom("NanumMyeongjo", size: 22))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.95), radius: 10)
                    .frame(width: 150, height: 48)
            }
            .buttonStyle(.plain)
            .position(x: figmaSize.width / 2, y: 780)
        }
        .frame(width: figmaSize.width, height: figmaSize.height)
        .clipped()
        .fullScreenCover(item: $activeRole) { role in
            if role.id == "의사" {
                DoctorChatView {
                    activeRole = nil
                }
            } else if role.id == "시민" {
                CitizenChatView {
                    activeRole = nil
                }
            } else {
                JournalistChatView {
                    activeRole = nil
                }
            }
        }
    }

    private var roleImage: some View {
        ZStack {
            Image(selectedRole.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: roleImageSize.width, height: roleImageSize.height)
                .offset(y: selectedRole.imageContentOffsetY)
        }
        .frame(width: roleImageSize.width, height: roleImageSize.height)
    }

    private var roleText: some View {
        VStack(spacing: 15) {
            Text(selectedRole.title)
                .font(.custom("NanumMyeongjoExtraBold", size: 32))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.65), radius: 6, y: 2)

            Image("Frame 1")
                .resizable()
                .scaledToFit()
                .frame(width: 93, height: 4.25)
                .padding(.bottom, 17)

            Text(selectedRole.subtitle)
                .font(.custom("NanumMyeongjo", size: 15))
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
