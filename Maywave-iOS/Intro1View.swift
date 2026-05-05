//
//  ContentView.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/5/26.
//

import SwiftUI

struct Intro1View: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
        }
    }
}

#Preview {
    Intro1View()
}
