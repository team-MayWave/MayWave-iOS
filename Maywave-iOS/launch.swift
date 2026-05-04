//
//  launch.swift
//  Maywave-iOS
//
//  Created by 김민준 on 5/5/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isLaunch: Bool = true
    
    var body: some View {
        ZStack {
            
            // 👉 메인 화면 (배경 이미지)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(isLaunch ? 0 : 1)
            
            // 👉 인트로 화면
            if isLaunch {
                Intro1View()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.8), value: isLaunch)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLaunch = false
            }
        }
    }
}

#Preview {
    ContentView()
}
