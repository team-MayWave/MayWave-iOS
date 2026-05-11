//
//  AppDelegate.swift
//  Maywave-iOS
//
//  Created by 김준표 on 5/11/26.
//

import UIKit
import AVFoundation

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        setupAudioSession()
        return true
    }

    private func setupAudioSession() {

        do {

            let session = AVAudioSession.sharedInstance()

            try session.setCategory(
                .playback,
                mode: .moviePlayback,
                options: [.mixWithOthers]
            )

            try session.setActive(true)

            print("🔊 Audio Session 설정 완료")

        } catch {

            print("❌ Audio Session 설정 실패: \(error)")
        }
    }
}
