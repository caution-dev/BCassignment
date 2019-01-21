//
//  Notification.swift
//  BoxOffice
//
//  Created by hyerikim on 16/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let loadNotificationKey = Notification.Name("com.boxOffice.load")
    static let startNotificationKey = Notification.Name("com.boxOffice.start")
    static let failNotificationKey = Notification.Name("com.boxOffice.fail")
    static let detailNotificationKey = Notification.Name("com.boxOffice.detail")
    static let commentNotificationKey = Notification.Name("com.boxOffice.comment")
}
