//
//  TabBarViewController.swift
//  BoxOffice
//
//  Created by hyerikim on 17/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let loadKey = Notification.Name(loadNotificationKey)
    let startKey = Notification.Name(startNotificationKey)
    let failKey = Notification.Name(failNotificationKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(resource: "http://connect-boxoffice.run.goorm.io/movies?order_type=0")

    }
    
}
