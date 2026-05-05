//
//  IntroSceneView.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/5/26.
//

import SwiftUI

struct IntroSceneData {
    let dateText: String
    let locationText: String
    let imageName: String
    let messages: [String]
}

struct IntroSceneView: View {

    let data: IntroSceneData

    @State private var showImage = false
    @State private var visibleMessageCount: Int = 0

    var body: some View {
        VStack(alignment: .center, spacing: 22) {

            
            VStack(spacing: 0) {
                HStack(spacing: 9) {
                    Image("LRectangle")

                    Text(data.dateText)
                        .font(.system(size: 15))
                        .foregroundColor(Color("detail"))

                    Image("RRectangle")
                }

                Text(data.locationText)
                    .font(.system(size: 12))
                    .foregroundColor(Color("detail"))
                    .padding(.top, 9)
            }
            .padding(.top, 49)

          
            Image(data.imageName)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
                .opacity(showImage ? 1 : 0)
                .scaleEffect(showImage ? 1 : 1.05)

           
            VStack(alignment: .center, spacing: 12) {
                ForEach(0..<visibleMessageCount, id: \.self) { idx in
                    Text(data.messages[idx])
                        .font(.system(size: 15))
                        .foregroundColor(Color("detail"))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }

        }
        .onAppear {
            runAnimation()
        }
    }

    private func runAnimation() {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeIn(duration: 1.0)) {
                showImage = true
            }

         
            for i in 0..<data.messages.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 + Double(i + 1)) {
                    withAnimation(.easeIn(duration: 0.8)) {
                        visibleMessageCount = min(visibleMessageCount + 1, data.messages.count)
                    }
                }
            }
        }
    }
}
