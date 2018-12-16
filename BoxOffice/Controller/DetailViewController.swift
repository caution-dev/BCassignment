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
    var cellIdentifier = "Cell"
    var commentList = [Comment]()
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
        tableView.register(UINib(nibName:"DetailTableViewCell",bundle: nil), forCellReuseIdentifier: "\(cellIdentifier)1")
        tableView.register(UINib(nibName:"CommentTableViewCell",bundle: nil), forCellReuseIdentifier: cellIdentifier)
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
                    self.commentList = response.comments
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
