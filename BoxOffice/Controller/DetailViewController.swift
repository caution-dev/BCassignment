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
    let url = "http://connect-boxoffice.run.goorm.io/movie?id="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        let defaultSession = URLSession(configuration: .default)
        guard let url = URL(string: "\(url)\(detailId)" ) else { return }
        let request = URLRequest(url: url)
        let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else { return } // 에러처리
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let apiResponse: DetailMovie = try JSONDecoder().decode(DetailMovie.self, from: data)
                    print(apiResponse)
                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
}
