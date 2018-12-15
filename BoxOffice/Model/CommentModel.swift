//
//  CommentModel.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let rating: Double
    let contents: String
    let movie_id: String
    let timestamp: Double
    let writer: String
}

struct CommentResponse: Codable {
    let comments: [Comment]
}
