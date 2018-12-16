//
//  DetailViewController.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let commentKey = Notification.Name(commentNotificationKey)
    private let detailKey = Notification.Name(detailNotificationKey)
    private let tabbar = TabBarViewController()
    private var cellIdentifier = "Cell"
    private var commentList = [Comment]()
    private var detailInfo: DetailMovie?

    var detailId: String = ""{
        willSet(value){
            loadData(resource: "http://connect-boxoffice.run.goorm.io/movie?id=\(value)")
            loadComment(resouce: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(value)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"DetailTableViewCell",bundle: nil), forCellReuseIdentifier: "\(cellIdentifier)1")
        tableView.register(UINib(nibName:"CommentTableViewCell",bundle: nil), forCellReuseIdentifier: cellIdentifier)
        createObserve()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.commentLoad), name: commentKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.detailLoad), name: detailKey, object: nil)
    }
    
    @objc private func commentLoad(notification: NSNotification) {
        guard let comment = notification.userInfo?["commentList"] as? [Comment] else { return }
        commentList = comment
        DispatchQueue.main.async {
            print("comment")
            self.tableView.reloadData()
        }
    }
    
    @objc private func detailLoad(notification: NSNotification) {
        guard let detail = notification.userInfo?["detailInfo"] as? DetailMovie else { return }
        detailInfo = detail
        DispatchQueue.main.async {
            print("detail")
            self.tableView.reloadData()
        }
    }
    
}

//MARK: tableview delegate and datasource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentList.count
        }
    }
    
    func checkStar(star: Double) -> Int {
        return Int(round(star/2))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(cellIdentifier)1", for: indexPath) as! DetailTableViewCell
            guard let imageURL = URL(string: detailInfo?.image ?? "") else { return cell }
            guard let imageData = try? Data(contentsOf: imageURL) else { return cell }

            cell.selectImage.image = tabbar.getCache(image: imageData)
            cell.titleLabel.text = detailInfo?.title
            cell.mainDateLabel.text = detailInfo?.date
            cell.detailLabel.text = detailInfo?.synopsis
            cell.userRatingLabel.text = detailInfo?.user_rating.description
            cell.userCountLabel.text = detailInfo?.audience.description
            cell.directorLabel.text = detailInfo?.director
            cell.actorLabel.text = detailInfo?.actor
            let count = checkStar(star: detailInfo?.user_rating ?? 0)
            
            switch count {
            case 5:
                cell.start5.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 4:
                cell.start4.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 3:
                cell.start3.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 2:
                cell.start2.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 1:
                cell.start1.image = UIImage(named: "ic_star_large_full")
                fallthrough
            default:
                break
            }
            
            if let grade = detailInfo?.grade {
                cell.gradeImage.image = UIImage(named: checkGrade(grade: grade))
            }
            
            if let genre = detailInfo?.genre, let duration = detailInfo?.duration {
                cell.descLabel.text = "\(genre)\(duration)분"
            }
            
            if let grade = detailInfo?.reservation_grade, let reservation = detailInfo?.reservation_rate {
                cell.ratingLabel.text = "\(grade)위 \(reservation)%"
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentTableViewCell
            cell.nickLabel.text = commentList[indexPath.row].writer
            cell.dateLabel.text = "\(commentList[indexPath.row].timestamp)"
            cell.commentLabel.text = commentList[indexPath.row].contents
            let count = checkStar(star: commentList[indexPath.row].rating)

            switch count {
            case 5:
                cell.star5.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 4:
                cell.star4.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 3:
                cell.star3.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 2:
                cell.star2.image = UIImage(named: "ic_star_large_full")
                fallthrough
            case 1:
                cell.star1.image = UIImage(named: "ic_star_large_full")
                fallthrough
            default:
                break
            }
            
            return cell
        }

    }
    
}
