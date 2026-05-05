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
            RoleSelectionView()
                .opacity(isLaunch ? 0 : 1)
            
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
