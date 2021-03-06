//
//  Navigation.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

extension UIViewController {

    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height - 100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "System", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func setRightButton() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_settings"), style: .done, target: self, action: #selector(UIViewController.clickSetting))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func clickSetting() {
        showAlertController(style:. actionSheet)
    }
    
    func showAlertController(style: UIAlertController.Style) {
        
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let noAction: UIAlertAction
        noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ticketAction: UIAlertAction
        ticketAction = UIAlertAction(title: "예매율", style: .default, handler: {(
            action: UIAlertAction) in
            self.getTypeData(orderType: 0, type: "예매율")
        })
        
        let curationAction: UIAlertAction
        curationAction = UIAlertAction(title: "큐레이션", style: .default, handler: {(
            action: UIAlertAction) in
            self.getTypeData(orderType: 1, type: "큐레이션")
        })
        
        let openAction: UIAlertAction
        openAction = UIAlertAction(title: "개봉일", style: .default, handler: {(
            action: UIAlertAction) in
            self.getTypeData(orderType: 2, type: "개봉일순")
        })
        
        alertController.addAction(noAction)
        alertController.addAction(ticketAction)
        alertController.addAction(curationAction)
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getTypeData(orderType: Int, type: String) {
        Singleton.shared.type = type
        Singleton.shared.typeOrder = orderType
        self.navigationItem.title = type
        NotificationCenter.default.post(name: .startNotificationKey, object: nil)
        getData(resource: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)")
    }
    
}
