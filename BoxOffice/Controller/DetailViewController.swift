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
    
    let tabbar = TabBarViewController()
    var detailCellIdentifier = "DetailCell"
    var commentCellIdentifier = "CommentCell"
    var comments = [Comment]()
    var detailInfo: DetailMovie?
    private let dispatchGroup = DispatchGroup()
    private let indicator = UIActivityIndicatorView()

    var detailId: String = ""{
        willSet(value){
            loadDetailData(value: value)
        }
    }
    
    var detailTitle: String = ""{
        willSet(value){
            self.navigationItem.title = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"DetailTableViewCell",bundle: nil), forCellReuseIdentifier: detailCellIdentifier)
        tableView.register(UINib(nibName:"CommentTableViewCell",bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        createIndicator()

        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    func createIndicator(){
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.backgroundColor = UIColor.black
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
}

//MARK: request detailview API
extension DetailViewController {
    
    func loadDetailData(value: String) {
        loadData(resource: "http://connect-boxoffice.run.goorm.io/movie?id=\(value)")
        loadComment(resouce: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(value)")
    }
    
    func loadComment(resouce: String) {
        guard let url = URL(string: resouce) else { return }
        let defaultSession = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        dispatchGroup.enter()
        let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else { return }
            guard let self = self else { return }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from: data)
                    self.comments = response.comments
                    self.dispatchGroup.leave()
                } catch(let error) {
                    print(error)
                }
            }
        }
        dataTask.resume()
        
    }
    
    func loadData(resource: String) {
        guard let url = URL(string: resource) else { return }
        let defaultSession = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        dispatchGroup.enter()
        let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else { return }
            guard let self = self else { return }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(DetailMovie.self, from: data)
                    self.detailInfo = response
                    self.dispatchGroup.leave()
                } catch (let error) {
                    print(error)
                }
            }
        }
        dataTask.resume()
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

