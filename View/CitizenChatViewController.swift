//
//  CitizenChatViewController.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/5/26.
//

import SwiftUI

struct CitizenChatView: View {
    @State private var showFirstChat = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                
                ZStack {
                    HStack {
                        Image("Arrow")
                        Spacer()
                    }

                    VStack(spacing: 4) {
                        Text("시민")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)

                        Text("1980년 5월 18일, 광주")
                            .font(.system(size: 15))
                            .foregroundColor(Color("Narration"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

             
                Rectangle()
                    .fill(Color("Narration"))                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                ScrollView {
                    VStack(alignment: .center, spacing: 22) {

                        IntroSceneView(
                            data: IntroSceneData(
                                dateText: "5월 18일",
                                locationText: "광주, 금남로",
                                imageName: "Basicscene",
                                messages: [
                                    "시내 분위기가 심상치 않습니다",
                                    "사람들이 모여들기 시작합니다"
                                ]
                            ),
                            onFinished: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showFirstChat = true
                                }
                            }
                        )
                        if showFirstChat {
                            ChatBubbleView(
                                name: "친구",
                                message: "전남대 쪽에서 학생들이 막혔다더라.\n계엄군이 들어왔대."
                            )
                        }

                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}


#Preview {
    CitizenChatView()
}
