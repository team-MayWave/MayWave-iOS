//
//  RecordSceneView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

struct RecordSceneView: View {
    let imageName: String
    var imageWidth: CGFloat = 348
    var imageHeight: CGFloat = 435
    let lines: [String]

    var body: some View {
        VStack(spacing: 22) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageHeight)

            VStack(spacing: 10) {
                Text("[기록]")
                    .font(.custom("NanumMyeongjo", size: 12))
                    .foregroundColor(Color("Narration"))

                Text("1980년 5월 19일")
                    .font(.custom("NanumMyeongjo", size: 11))
                    .foregroundColor(Color("Narration"))

                VStack(spacing: 12) {
                    ForEach(lines, id: \.self) { line in
                        Text(line)
                            .font(.custom("NanumMyeongjo", size: 12))
                            .foregroundColor(Color("Narration"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecordSceneView(
            imageName: "threescene",
            lines: [
                "더 많은 시민들이 거리로 나왔습니다.",
                "당신의 선택은 기록으로 남았습니다."
            ]
        )
    }
}
