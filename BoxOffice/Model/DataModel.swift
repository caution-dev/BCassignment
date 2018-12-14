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
    
}

struct APIResponse: Codable {
    let movies: [Movies]
}
