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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: failNotificationKey), object: nil)
            return
        }
        
        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let apiResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                Singleton.shared.movieList = apiResponse.movies
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: loadNotificationKey), object: nil, userInfo: ["movieList":apiResponse.movies])
            } catch (let error) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: failNotificationKey), object: nil)
                print(error)
            }
        }
    }
    dataTask.resume()
}

func loadComment(resouce: String) {
    guard let url = URL(string: resouce) else { return }
    let defaultSession = URLSession(configuration: .default)
    let request = URLRequest(url: url)
    let dataTask = defaultSession.dataTask(with: request) { data, response, error in
        guard error == nil else { return } // 에러처리
        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let response = try JSONDecoder().decode(CommentResponse.self, from: data)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: commentNotificationKey), object: nil, userInfo: ["commentList":response.comments])
            } catch(let error) {
                print(error)
            }
        }
    }
    dataTask.resume()
}

func loadData(resource: String) {
    guard let url = URL(string: resource) else { return }
    let defaultSession = URLSession(configuration: .default)
    let request = URLRequest(url: url)
    let dataTask = defaultSession.dataTask(with: request) { data, response, error in
        guard error == nil else { return } // 에러 처리
        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                let response = try JSONDecoder().decode(DetailMovie.self, from: data)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: detailNotificationKey), object: nil, userInfo: ["detailInfo":response])
            } catch (let error) {
                print(error)
            }
        }
    }
    dataTask.resume()
}
