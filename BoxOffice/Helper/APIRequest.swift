//
//  APIRequest.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

func getData(resource: String) {
    guard let url = URL(string: resource) else { return }
    let defaultSession = URLSession(configuration: .default)
    let request = URLRequest(url: url)
    let dataTask = defaultSession.dataTask(with: request) { data, response, error in
        guard error == nil else {
            NotificationCenter.default.post(name: .failNotificationKey, object: nil)
            return
        }
        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let apiResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                Singleton.shared.movieList = apiResponse.movies
                NotificationCenter.default.post(name: .loadNotificationKey, object: nil, userInfo: ["movieList":apiResponse.movies])
            } catch (let error) {
                NotificationCenter.default.post(name: .failNotificationKey, object: nil)
                print(error)
            }
        }
    }
    dataTask.resume()
}
