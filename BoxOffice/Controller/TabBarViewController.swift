//
//  TabBarViewController.swift
//  BoxOffice
//
//  Created by hyerikim on 17/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    lazy var imageCache = NSCache<AnyObject, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    func getCache(image: Data) -> UIImage? {
        if let existimageCache = imageCache.object(forKey: image as AnyObject) {
            return existimageCache as? UIImage
        } else {
            let imageToCache = UIImage(data: image)
            imageCache.setObject(imageToCache!, forKey: image as AnyObject)
            return imageToCache
        }
    }
    
}
