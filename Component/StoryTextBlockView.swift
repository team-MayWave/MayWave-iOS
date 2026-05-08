//
//  StoryTextBlockView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

struct StoryTextBlockView: View {
    let lines: [String]
    @State private var visibleLineCount = 0

    var body: some View {
        VStack(spacing: 15) {
            ForEach(Array(lines.prefix(visibleLineCount)), id: \.self) { line in
                Text(line)
                    .font(.custom("NanumMyeongjo", size: 13))
                    .foregroundColor(Color("Narration"))
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .onAppear {
            guard visibleLineCount == 0 else { return }

            for index in lines.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.0) {
                    withAnimation(.easeOut(duration: 0.45)) {
                        visibleLineCount = min(index + 1, lines.count)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        StoryTextBlockView(
            lines: [
                "당신은 불안함 속에서도 발걸음을 옮겼습니다.",
                "당시에도 많은 시민들이",
                "무슨 일이 일어나고 있는지 직접 확인하려 했습니다."
            ]
        )
    }
}
