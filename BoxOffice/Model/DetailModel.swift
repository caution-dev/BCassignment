//
//  DetailModel.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

struct DetailMovie: Codable {
    
    let actor: String
    let audience: Int
    let date: String
    let director: String
    let duration: Int
    let genre: String
    let grade: Int
    let id: String
    let image: String
    let reservation_grade: Int
    let reservation_rate: Double
    let user_rating: Double
    let synopsis: String
    let title: String
    
}
