//
//  Grade.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

enum Grade: Int {
    case all = 0
    case twelve = 12
    case fifteen = 15
    case nineteen = 19
    
    var image: UIImage? {
        switch self {
        case .all:
            return UIImage(named: "ic_allages")
        case .twelve:
            return UIImage(named: "ic_12")
        case .fifteen:
            return UIImage(named: "ic_15")
        case .nineteen:
            return UIImage(named: "ic_19")
        }
    }
}
