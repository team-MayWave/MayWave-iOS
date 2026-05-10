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
    var dateText: String = "1980년 5월 19일"
    let lines: [String]
    @State private var typedLines: [String]
    @State private var typingTask: Task<Void, Never>?

    init(
        imageName: String,
        imageWidth: CGFloat = 348,
        imageHeight: CGFloat = 435,
        dateText: String = "1980년 5월 19일",
        lines: [String]
    ) {
        self.imageName = imageName
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.dateText = dateText
        self.lines = lines
        _typedLines = State(initialValue: lines.map { _ in "" })
    }

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

                VStack(spacing: 3) {
                    Text("-----------------------------")
                    Text(dateText)
                    Text("-----------------------------")
                }
                .font(.custom("NanumMyeongjo", size: 11))
                .foregroundColor(Color("Narration"))

                VStack(spacing: 12) {
                    ForEach(lines.indices, id: \.self) { index in
                        Text(typedLines.indices.contains(index) ? typedLines[index] : "")
                            .font(.custom("NanumMyeongjo", size: 12))
                            .foregroundColor(Color("Narration"))
                            .multilineTextAlignment(.center)
                            .frame(minHeight: 15)
                    }
                }
                .padding(.top, 8)
            }
        }
        .onAppear {
            startTyping()
        }
        .onDisappear {
            typingTask?.cancel()
            typingTask = nil
        }
    }

    private func startTyping() {
        typingTask?.cancel()
        typedLines = lines.map { _ in "" }

        typingTask = Task {
            for lineIndex in lines.indices {
                let characters = Array(lines[lineIndex])

                for characterIndex in characters.indices {
                    guard !Task.isCancelled else { return }

                    try? await Task.sleep(nanoseconds: 70_000_000)
                    guard !Task.isCancelled else { return }

                    let typedText = String(characters[...characterIndex])
                    await MainActor.run {
                        guard typedLines.indices.contains(lineIndex) else { return }
                        typedLines[lineIndex] = typedText
                    }
                }

                guard !Task.isCancelled else { return }
                try? await Task.sleep(nanoseconds: 550_000_000)
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
