//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by hyerikim on 14/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier = "Cell"
    private var movieList = [Movies]()
    private let refresh = UIRefreshControl()
    private let indicator = UIActivityIndicatorView()
    private let tabbar = TabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRightButton()
        createObserve()
        createIndicator()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Singleton.shared.type
        if let getMovieList = Singleton.shared.movieList {
            movieList = getMovieList
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let cell = sender as? CollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                destination.detailId = movieList[indexPath.row].id
                destination.detailTitle = movieList[indexPath.row].title
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: set up view
    func createIndicator() {
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.backgroundColor = UIColor.black
        self.view.addSubview(indicator)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresh
        } else {
            collectionView.addSubview(refresh)
        }
        
        refresh.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
}

//MARK: api response notification
extension CollectionViewController {
    func createObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(notification:)), name: .loadNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.indicatorStart), name: .startNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failMessage), name: .failNotificationKey, object: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        getData(resource: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(Singleton.shared.typeOrder)")
    }
    
    @objc func indicatorStart(notification: NSNotification) {
        indicator.startAnimating()
    }
    
    @objc func failMessage() {
        showToast(message: "데이터 로드 실패")
    }
    
    @objc func updateData(notification: NSNotification) {
        guard let getMovieList = notification.userInfo?["movieList"] as? [Movies] else { return }
        Singleton.shared.movieList = getMovieList
        movieList = getMovieList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            self.indicator.stopAnimating()
            
        }
    }
    
}

//MARK: collectionview delegate and datasource
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: self.movieList[indexPath.row].thumb) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                cell.imageView.image = self.tabbar.getCache(image: imageData)
            }
        }

        cell.titleLabel.text = movieList[indexPath.row].title
        cell.descLabel.text = " \(movieList[indexPath.row].reservation_grade)위 (\(movieList[indexPath.row].user_rating)) / \(movieList[indexPath.row].reservation_rate)"
        cell.dateLabel.text = movieList[indexPath.row].date
        cell.gradeImage.image = UIImage(named: checkGrade(grade: movieList[indexPath.row].grade))

        return cell
    }
    
}
