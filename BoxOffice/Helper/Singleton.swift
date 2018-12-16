//
//  Singleton.swift
//  BoxOffice
//
//  Created by hyerikim on 16/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

class Singleton {
    
    private init() {}
    static let shared = Singleton()
    
    var movieList: [Movies]?
    var type = "예매율순"
    var typeOrder = 0
}
