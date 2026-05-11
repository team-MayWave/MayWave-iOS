//
//  sever.swift
//  Maywave-iOS
//
//  Created by 김민준 on 5/11/26.
//

import Foundation

class GameAPI {
    
    static func playGame() {
        
        guard let url = URL(string: "http://ssh.gsmsv.site:22119/api/game/play") else {
            print("URL 오류")
            return
        }
        
        print("최종 URL:", url.absoluteString)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("서버 연결 실패:", error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("상태 코드:", response.statusCode)
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            let result = String(data: data, encoding: .utf8)
            print("서버 응답:", result ?? "")
            
        }.resume()
    }
}
