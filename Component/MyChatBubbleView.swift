//
//  MyChatBubbleView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

struct MyChatBubbleView: View {
    let name: String
    let message: String
    @State private var isVisible = false

    var body: some View {
        HStack(alignment: .top) {
            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(name)
                    .font(.custom("NanumMyeongjo", size: 11))
                    .foregroundColor(Color.white.opacity(0.65))
                    .padding(.trailing, 20)

                Text(message)
                    .font(.custom("NanumMyeongjo", size: 13))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.25))
                    )
            }
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .padding(.horizontal, 43)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MyChatBubbleView(name: "나", message: "무슨 일인데?")
    }
}
