//
//  StoryImageView.swift
//  Maywave-iOS
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

struct StoryImageView: View {
    let imageName: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        StoryImageView(imageName: "twoscene", width: 357, height: 268)
    }
}
