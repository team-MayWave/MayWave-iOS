//
//  sever.swift
//  Maywave-iOS
//
//  Created by 김민준 on 5/11/26.
//

import Foundation

class GameAPI {
    
    static func playGame(roleId: Int, scenarioId: Int, choice: Int) {
        
        guard let url = URL(string: "http://ssh.gsmsv.site:22119/api/game/play") else {
            print("URL 오류")
            return
        }
        
        let body: [String: Int] = [
            "roleId": roleId,
            "scenarioId": scenarioId,
            "choice": choice
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("최종 URL:", url.absoluteString)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
