//
//  ChatBubbleView.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/5/26.
//


import SwiftUI

struct ChatBubbleView: View {
    let name: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
         
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .overlay(
                    Image( "profile")
                )

            VStack(alignment: .leading, spacing: 6) {
                
                Text(name)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.7))

              
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.25))
                    )
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ChatBubbleView(
            name: "친구",
            message: "전남대 쪽에서 학생들이 막혔다더라.\n계엄군이 들어왔대."
        )
    }
}
