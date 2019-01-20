//
//  ViewController.swift
//  BoxOffice
//
//  Created by hyerikim on 14/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "Cell"
    private let refreshController = UIRefreshControl()
    private let indicator = UIActivityIndicatorView()
    private let tabbar = TabBarViewController()
    private var movieList = Singleton.shared.movieList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRightButton()
        createObserve()
        createIndicator()
        getData(resource: "http://connect-boxoffice.run.goorm.io/movies?order_type=0")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Singleton.shared.type
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let movie = movieList {
                destination.detailId = movie[indexPath.row].id
                destination.detailTitle = movie[indexPath.row].title
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: set up view
    func createIndicator(){
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.backgroundColor = UIColor.black
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshController
        } else {
            tableView.addSubview(refreshController)
        }
        
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
}

//MARK: api response notification
extension TableViewController {
    
    func createObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(notification:)), name: tabbar.loadKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.indicatorStart), name: tabbar.startKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failMessage), name: tabbar.failKey, object: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        getData(resource: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(Singleton.shared.typeOrder)")
    }
    
    @objc func failMessage() {
        showToast(message: "데이터 로드 실패")
    }
    
    @objc func indicatorStart(notification: NSNotification) {
        indicator.startAnimating()
    }
    
    @objc func updateData(notification: NSNotification) {
        guard let getMovieList = notification.userInfo?["movieList"] as? [Movies] else { return }
        movieList = getMovieList
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.refreshController.endRefreshing()
        }
    }
    
}

//MARK: tableview delegate and datasource
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
//        guard let movie = movieList[indexPath.row] as? Movies else { return cell }
        guard let movie = movieList?[indexPath.row] else { return cell }
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: movie.thumb) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                cell.thumbImage.image = self.tabbar.getCache(image: imageData)
            }
        }
        
        cell.configure(data: movie)
        return cell
    }
    
}
