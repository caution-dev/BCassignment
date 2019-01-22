//
//  DetailView.swift
//  BoxOffice
//
//  Created by hyerikim on 17/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit


//MARK: tableview delegate and datasource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
    
    func checkStar(star: Double) -> Int {
        return Int(round(star/2))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath) as! DetailTableViewCell
            
            DispatchQueue.global().async {
                guard let imageURL = URL(string: self.detailInfo?.image ?? "") else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                DispatchQueue.main.async {
                    cell.selectImage.image = self.tabbar.getCache(image: imageData)
                }
            }
      
            cell.titleLabel.text = detailInfo?.title
            cell.mainDateLabel.text = detailInfo?.date
            cell.detailLabel.text = detailInfo?.synopsis
            cell.userRatingLabel.text = detailInfo?.user_rating.description
            cell.userCountLabel.text = detailInfo?.audience.description
            cell.directorLabel.text = detailInfo?.director
            cell.actorLabel.text = detailInfo?.actor
            let count = checkStar(star: detailInfo?.user_rating ?? 0)
            
            for i in 0..<count {
                cell.starImageViews[i].image = UIImage(named: "ic_star_large_full")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier, for: indexPath) as! CommentTableViewCell
            let comment = comments[indexPath.row]
            cell.nickLabel.text = comment.writer
            cell.dateLabel.text = "\(comment.timestamp)"
            cell.commentLabel.text = comment.contents
            let count = checkStar(star: comment.rating)
        
            for i in 0..<count {
                cell.starImageViews[i].image = UIImage(named: "ic_star_large_full")
            }
            
            return cell
        }
    }
}
