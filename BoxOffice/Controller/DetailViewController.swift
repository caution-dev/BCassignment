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
    
    var detailId = ""
    private let detailUrl = "http://connect-boxoffice.run.goorm.io/movie?id="
    private let commentUrl = "http://connect-boxoffice.run.goorm.io/comments?movie_id="
    private var cellIdentifier = "Cell"
    private var commentList = [Comment]()
    private var detailInfo: DetailMovie?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"DetailTableViewCell",bundle: nil), forCellReuseIdentifier: "\(cellIdentifier)1")
        tableView.register(UINib(nibName:"CommentTableViewCell",bundle: nil), forCellReuseIdentifier: cellIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        loadComment()
    }
    
    func loadComment() {
        let defaultSession = URLSession(configuration: .default)
        guard let url = URL(string: "\(commentUrl)\(detailId)") else { return }
        let request = URLRequest(url: url)
        let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else { return } // 에러처리
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from: data)
                    self.commentList = response.comments
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch(let error) {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    func loadData() {
        let defaultSession = URLSession(configuration: .default)
        guard let url = URL(string: "\(detailUrl)\(detailId)" ) else { return }
        let request = URLRequest(url: url)
        let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else { return } // 에러 처리
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(DetailMovie.self, from: data)
                    self.navigationItem.title = response.title
                    self.detailInfo = response
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(response)
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
    
    func checkStar(star: Double) {
        print(star/2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(cellIdentifier)1", for: indexPath) as! DetailTableViewCell
            guard let imageURL = URL(string: detailInfo?.image ?? "") else { return cell }
            guard let imageData = try? Data(contentsOf: imageURL) else { return cell }
            
            cell.selectImage.image = UIImage(data: imageData)
            cell.titleLabel.text = detailInfo?.title
            cell.mainDateLabel.text = detailInfo?.date
            cell.detailLabel.text = detailInfo?.synopsis
            cell.userRatingLabel.text = detailInfo?.user_rating.description
            cell.userCountLabel.text = detailInfo?.audience.description
            cell.directorLabel.text = detailInfo?.director
            cell.actorLabel.text = detailInfo?.actor
            checkStar(star: detailInfo?.user_rating ?? 0)
            
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
            return cell
        }

    }
    
}
