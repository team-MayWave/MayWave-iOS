//
//  EndingTextView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/6/26.
//

import SwiftUI

struct EndingTextView: View {
    let lines: [String]
    var showDate: Bool = false
    @State private var isVisible = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 11) {
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(.custom("NanumMyeongjo", size: 15))
                        .foregroundColor(.white.opacity(0.82))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 42)

            if showDate {
                Text("1980.05.18")
                    .font(.custom("NanumMyeongjo", size: 11))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.trailing, 10)
                    .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .onAppear {
            withAnimation(.easeOut(duration: 0.55)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        EndingTextView(
            lines: [
                "그날,",
                "많은 시민들이 거리로 나섰고,",
                "또 다른 이들은",
                "그 자리에 서서 상황을 지켜봤습니다."
            ]
        )
    }
}
