//
//  Navigation.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setRightButton() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_settings"), style: .done, target: self, action: #selector(UIViewController.clickSetting))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func clickSetting() {
        showAlertController(style:. actionSheet)
    }
    
    func showAlertController(style: UIAlertController.Style){
        
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let noAction: UIAlertAction
        noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ticketAction: UIAlertAction
        ticketAction = UIAlertAction(title: "예매율", style: .default, handler: {(
            action: UIAlertAction) in
            self.navigationItem.title = "예매율순"
            NotificationCenter.default.post(name: Notification.Name(loadNotificationKey), object: 0)
            
            //0 default http://connect-boxoffice.run.goorm.io/movies?order_type=0
        })
        
        let curationAction: UIAlertAction
        curationAction = UIAlertAction(title: "큐레이션", style: .default, handler: {(
            action: UIAlertAction) in
            self.navigationItem.title = "큐레이션"
            NotificationCenter.default.post(name: Notification.Name(loadNotificationKey), object: 1)

            //1 http://connect-boxoffice.run.goorm.io/movies?order_type=1
        })
        
        let openAction: UIAlertAction
        openAction = UIAlertAction(title: "개봉일", style: .default, handler: {(
            action: UIAlertAction) in
            self.navigationItem.title = "개봉일순"
            NotificationCenter.default.post(name: Notification.Name(loadNotificationKey), object: 2)

            //2 http://connect-boxoffice.run.goorm.io/movies?order_type=2
        })
        
        alertController.addAction(noAction)
        alertController.addAction(ticketAction)
        alertController.addAction(curationAction)
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
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
    
}

