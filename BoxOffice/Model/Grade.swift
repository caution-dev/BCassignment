//
//  Grade.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

enum Grade: String {
    case all = "ic_allages"
    case twelve = "ic_12"
    case fifteen = "ic_15"
    case nineteen = "ic_19"
}

func checkGrade(grade: Int) -> String {
    switch grade {
    case 12:
        return Grade.twelve.rawValue
    case 15:
        return Grade.fifteen.rawValue
    case 19:
        return Grade.nineteen.rawValue
    default:
        return Grade.all.rawValue
    }
}
