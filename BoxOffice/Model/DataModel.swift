//
//  DataModel.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

struct Movies: Codable {
    
    let date: String
    let grade: Int
    let id: String
    let reservation_grade: Int
    let reservation_rate: Double
    let thumb: String
    let title: String
    let user_rating: Double
    
    var newDescLabel: String {
        return "평점: \(user_rating) 예매순위: \(reservation_grade) 예매율: \(reservation_rate)"
    }
    
}

struct MoviesResponse: Codable {
    let movies: [Movies]
}
