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
    let id: Int
    let thumb: String
    let title: String
    let user_rating: String

    init(date: String, grade: Int, id: Int, thumb: String, title: String, user_rating: String) {
        self.date = date
        self.grade = grade
        self.id = id
        self.thumb = thumb
        self.title = title
        self.user_rating = user_rating
    }
    
}

struct APIResponse: Codable {
    let movieList: [Movies]
}
