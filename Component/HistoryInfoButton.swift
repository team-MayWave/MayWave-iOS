//
//  HistoryInfoButton.swift
//  Maywave-iOS
//
//  Created by Codex on 5/10/26.
//

import SwiftUI

struct HistoryInfoData: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let imageSize: CGSize
    let imageCornerRadius: CGFloat
    let dateText: String?
    let body: String
    let source: String
    let titleSize: CGFloat
    let subtitleSize: CGFloat
    let imageTop: CGFloat
}

extension HistoryInfoData {
    static let resistanceStart = HistoryInfoData(
        id: "resistanceStart",
        title: "광주의 저항이 시작된 날",
        subtitle: "시민들과 학생들은 계엄 확대와\n유혈 진압에 맞서 항거했습니다.",
        imageName: "image 38",
        imageSize: CGSize(width: 170, height: 235),
        imageCornerRadius: 0,
        dateText: nil,
        body: """
        1980년 광주의 끔찍한 사건은 1979년 10월 26일 박정희 前 대통령 사망 이후, 유신독재 정권의 수혜자였던 전두환, 노태우를 위시한 신군부집단이 12.12쿠데타로 군권을 장악하고 정권 탈취의 야욕을 드러내며 시작된다.

        1980년 5월 17일 비상계엄 전국 확대에 따라 취해진 계엄군의 유혈 진압에 맞서 광주시민들과 학생들은 계엄 해제와 민주화를 요구하며 항거했다.
        """,
        source: "출처: 5·18민주화운동기록관",
        titleSize: 22,
        subtitleSize: 15,
        imageTop: 110
    )

    static let geumnamroMarch = HistoryInfoData(
        id: "geumnamroMarch",
        title: "학생들이 금남로로 향하기 시작한 순간",
        subtitle: "시민들은 “금남로로 가자”를 외치며 이동했습니다.\n시위는 광주 시내로 퍼져갔습니다.",
        imageName: "sixscene",
        imageSize: CGSize(width: 321, height: 210),
        imageCornerRadius: 6,
        dateText: "1980년 5월 18일 오전 10시 20분",
        body: "전남대학교 정문 앞에 모인 학생들은 “금남로로 가자”는 구호를 외치며 금남로 방향으로 이동하기 시작했습니다. 이후 학생들의 행렬은 광주 시내로 이어졌고, 시민들도 하나둘 거리로 나오기 시작했습니다.",
        source: "출처: 5·18민주화운동기록관",
        titleSize: 18,
        subtitleSize: 14,
        imageTop: 126
    )

    static let citizensOnStreet = HistoryInfoData(
        id: "citizensOnStreet",
        title: "시민들이 거리로 나온 날",
        subtitle: "계엄령 확대와 언론 통제에 분노한 시민들이\n민주화를 요구하며 거리로 나섰습니다.",
        imageName: "image 37",
        imageSize: CGSize(width: 321, height: 210),
        imageCornerRadius: 6,
        dateText: "1980년 5월 18일 오전 10시경",
        body: "1980년 5월 17일 밤, 전남대에서 진주한 계엄군은 도서관 등 공부하고 있던 학생들을 무자비하게 구타하고 불법 구금하였다. 다음 날인 5월 18일 아침 학교에 등교하거나 5.17비상계엄확대조치에 항의하기 위해 정문 앞에 모인 학생들을 무자비하게 강제해산시켰다. 이에 학생들이 항의하면서 항쟁의 불씨가 되었다.",
        source: "출처: 5·18민주화운동기록관",
        titleSize: 20,
        subtitleSize: 14,
        imageTop: 126
    )

    static let martialControl = HistoryInfoData(
        id: "martialControl",
        title: "계엄군이 광주를 통제하기 시작한 날",
        subtitle: "계엄군과 시민들의 충돌이 이어졌습니다.\n이후 광주에서는 최초의 총격 사건이 발생했습니다.",
        imageName: "image 39",
        imageSize: CGSize(width: 325, height: 214),
        imageCornerRadius: 6,
        dateText: "1980년 5월 19일 오후 4시경",
        body: "시위 진압차 출동한 11공수여단과 63대 소속 장갑차가 계림동 광주고교 부근(250-91번지)에서 시위대에 포위되어 공격을 당하자 안에 타고 있던 차 아무개 대위가 해치를 열고 M16을 난사. 고교생 김영찬(김영찬), 초등학생 2명, 중학생 2명이 중상을 입는다.",
        source: "출처: 수사기록·증언일지",
        titleSize: 17,
        subtitleSize: 14,
        imageTop: 126
    )

    static let streetTreatmentStarted = HistoryInfoData(
        id: "streetTreatmentStarted",
        title: "거리에서 치료가 시작된 순간",
        subtitle: "부상자들이 계속 늘어나고 있었습니다.\n의료진은 거리에서 치료를 이어갔습니다.",
        imageName: "image 45",
        imageSize: CGSize(width: 321, height: 210),
        imageCornerRadius: 6,
        dateText: nil,
        body: """
        계엄군의 강경 진압으로 거리 곳곳에서 부상자가 발생하기 시작했습니다.

        병원으로 옮길 수 없는 상황에서는 의료진과 시민들이 길거리에서 직접 응급 처치를 이어갔고, 의대생과 간호사들도 부상자 구조에 참여했습니다.

        당시 광주기독병원과 전남대병원 의료진들은 부족한 의료 물품 속에서도 시민들을 치료하고 있었습니다.
        """,
        source: "출처: 5·18민주화운동기록관",
        titleSize: 18,
        subtitleSize: 14,
        imageTop: 126
    )

    static let hospitalFull = HistoryInfoData(
        id: "hospitalFull",
        title: "병원이 부상자들로 가득 찬 날",
        subtitle: "병원에는 부상자들이 계속 실려왔습니다.\n의료진은 부족한 인력 속에서 치료를 이어가야 했습니다.",
        imageName: "image 48",
        imageSize: CGSize(width: 321, height: 210),
        imageCornerRadius: 6,
        dateText: nil,
        body: """
        계엄군의 강경 진압으로 광주 시내 곳곳에서 부상자가 발생했고, 전남대병원과 광주기독병원에는 시민들이 계속해서 실려오기 시작했습니다.

        의료진과 간호사, 의대생들은 부족한 약품과 인력 속에서도 밤낮 없이 치료를 이어갔으며, 병원 복도와 응급실까지 부상자들로 가득 차기 시작했습니다.

        당시 일부 시민들은 직접 헌혈과 환자 이송에 참여하며 구조 활동을 도왔습니다.
        """,
        source: "출처: 5·18민주화운동기록관",
        titleSize: 18,
        subtitleSize: 14,
        imageTop: 126
    )

    static let hospitalConfusion = HistoryInfoData(
        id: "hospitalConfusion",
        title: "병원이 혼란으로 가득 찬 날",
        subtitle: "병원에는 계속해서 부상자들이 실려왔습니다.\n의료진은 부족한 인력 속에서 치료를 이어가야 했습니다.",
        imageName: "image 47",
        imageSize: CGSize(width: 321, height: 210),
        imageCornerRadius: 6,
        dateText: nil,
        body: """
        계엄군의 강경 진압이 이어지면서 전남대병원과 광주기독병원에는 수많은 부상자들이 실려오기 시작했습니다.

        의료진과 간호사, 의대생들은 부족한 의료 물품과 인력 속에서도 밤낮 없이 시민들의 치료를 이어가야 했습니다.

        병원 복도와 응급실은 부상자들로 가득 찼고, 일부 시민들은 직접 헌혈과 환자 이송에 참여하기도 했습니다.
        """,
        source: "출처: 5·18민주화운동기록관",
        titleSize: 18,
        subtitleSize: 14,
        imageTop: 126
    )

    static let journalistCrackdownStarted = HistoryInfoData(
        id: "journalistCrackdownStarted",
        title: "공수부대의 진압이 시작된 날",
        subtitle: "공수부대가 유동 3거리에 투입되기 시작했습니다.\n거리 곳곳에서는 강경 진압과 폭력이 이어졌습니다.",
        imageName: "image 39",
        imageSize: CGSize(width: 325, height: 214),
        imageCornerRadius: 6,
        dateText: "1980년 5월 18일 오후 3시 40분",
        body: "유동 3거리 일대에 공수부대가 투입되면서 시민들과 학생들에 대한 강경 진압이 본격적으로 시작되었습니다. 계엄군은 시위대를 무차별적으로 폭행하고 강제 해산시켰으며, 광주 시내 곳곳에서는 충돌과 폭력 상황이 이어졌습니다.",
        source: "출처: 5·18민주화운동기록관",
        titleSize: 17,
        subtitleSize: 13,
        imageTop: 126
    )
}

struct HistoryInfoButton: View {
    @Binding var isPresented: Bool
    @Binding var hasRead: Bool
    let showsBadge: Bool
    @State private var alertOffset: CGFloat = 0

    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.25)) {
                isPresented = true
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundColor(.white.opacity(0.42))

                if showsBadge && !hasRead {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.06, blue: 0.06))
                        .frame(width: 12, height: 12)
                        .offset(x: -3, y: alertOffset)
                }
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onAppear {
            runUnreadMotionIfNeeded()
        }
        .onChange(of: showsBadge && !hasRead) { _, isUnread in
            if isUnread {
                runUnreadMotionIfNeeded()
            }
        }
    }

    private func runUnreadMotionIfNeeded() {
        guard showsBadge && !hasRead else {
            alertOffset = 0
            return
        }

        alertOffset = 0
        withAnimation(.easeInOut(duration: 0.22).repeatCount(16, autoreverses: true)) {
            alertOffset = -5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            alertOffset = 0
        }
    }
}

struct HistoryInfoOverlay: View {
    let info: HistoryInfoData
    let onClose: () -> Void

    init(info: HistoryInfoData = .resistanceStart, onClose: @escaping () -> Void) {
        self.info = info
        self.onClose = onClose
    }

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = min(CGFloat(356), proxy.size.width - 24)
            let infoWidth = min(CGFloat(330), cardWidth - 26)

            ZStack(alignment: .top) {
                Color.black.opacity(0.72)
                    .ignoresSafeArea()

                ZStack(alignment: .topLeading) {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                            .frame(width: 34, height: 34, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .offset(x: 8, y: 8)

                    Text(info.title)
                        .font(.custom("NanumMyeongjoExtraBold", size: info.titleSize))
                        .foregroundColor(.white)
                        .frame(width: cardWidth, height: 28, alignment: .center)
                        .offset(x: 0, y: 24)

                    Text(info.subtitle)
                        .font(.custom("NanumMyeongjo", size: info.subtitleSize))
                        .foregroundColor(.white.opacity(0.62))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .frame(width: cardWidth - 34, height: 44, alignment: .top)
                        .offset(x: 17, y: 57)

                    Image(info.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: info.imageSize.width, height: info.imageSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: info.imageCornerRadius))
                        .opacity(0.95)
                        .offset(x: (cardWidth - info.imageSize.width) / 2, y: info.imageTop)

                    historyBox
                        .frame(width: infoWidth, height: 176, alignment: .topLeading)
                        .background(Color(red: 39 / 255, green: 39 / 255, blue: 38 / 255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 71 / 255, green: 71 / 255, blue: 71 / 255), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: (cardWidth - infoWidth) / 2, y: 364)
                }
                .frame(width: cardWidth, height: 558, alignment: .top)
                .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 25 / 255, green: 25 / 255, blue: 25 / 255), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.35), radius: 20, y: 12)
                .position(x: proxy.size.width / 2, y: 165 + 558 / 2)
            }
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }

    private var historyBox: some View {
        ZStack(alignment: .topLeading) {
            let horizontalPadding: CGFloat = 20
            let contentWidth: CGFloat = 290

            HStack(spacing: 8) {
                Image("free-icon-light-bulb-3349308 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text("역사적 배경")
                    .font(.custom("NanumMyeongjoExtraBold", size: 17))
                    .foregroundColor(Color(red: 0.98, green: 0.91, blue: 0.66))
            }
            .offset(x: horizontalPadding, y: 14)

            if let dateText = info.dateText {
                Text(dateText)
                    .font(.custom("NanumMyeongjo", size: 10))
                    .foregroundColor(.white.opacity(0.72))
                    .frame(width: contentWidth, height: 14, alignment: .topLeading)
                    .offset(x: horizontalPadding, y: 45)
            }

            Text(info.body)
                .font(.custom("NanumMyeongjo", size: info.dateText == nil ? 12.4 : 10.3))
                .foregroundColor(.white.opacity(0.72))
                .lineSpacing(1)
                .lineLimit(info.dateText == nil ? 9 : 10)
                .minimumScaleFactor(info.dateText == nil ? 0.78 : 0.74)
                .allowsTightening(true)
                .frame(width: contentWidth, height: info.dateText == nil ? 104 : 86, alignment: .topLeading)
                .offset(x: horizontalPadding, y: info.dateText == nil ? 50 : 66)

            Text(info.source)
                .font(.custom("NanumMyeongjo", size: 8))
                .foregroundColor(.white.opacity(0.46))
                .frame(width: contentWidth, height: 18, alignment: .trailing)
                .offset(x: horizontalPadding, y: 150)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HistoryInfoOverlay {}
    }
}
