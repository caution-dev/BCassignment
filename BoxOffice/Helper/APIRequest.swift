//
//  APIRequest.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

func getData(resource: String) {
    let defaultSession = URLSession(configuration: .default)
    guard let url = URL(string: "\(resource)") else { return }
    let request = URLRequest(url: url)
    let dataTask = defaultSession.dataTask(with: request) { data, response, error in
        guard error == nil else {
            
            return
        } // 에러처리
        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: loadNotificationKey), object: nil, userInfo: ["movieList":apiResponse.movies])
            } catch (let error) {
                print(error)
            }
        }
    }
    dataTask.resume()
}

class Singleton {
    
    private init() {}
    static let shared = Singleton()
    
    var movieList: [Movies]?
    var type = "예매율순"

}

