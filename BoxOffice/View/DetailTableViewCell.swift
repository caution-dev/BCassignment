//
//  DetailTableViewCell.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var starImageViews: [UIImageView]!
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainDateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    override func prepareForReuse() {
        initStarImageViews()
    }
    
    private func initStarImageViews() {
        for i in stride(from: 0, to: 5, by: 1) {
            starImageViews[i].image = UIImage(named: "ic_star_large")
        }
    }
}
