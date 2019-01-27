//
//  TableViewCell.swift
//  BoxOffice
//
//  Created by hyerikim on 14/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(data: Movies) {
        titleLabel.text = data.title
        descLabel.text = data.newDescLabel
        dateLabel.text = "개봉일: \(data.date)"
        gradeImage.image = UIImage(named: checkGrade(grade: data.grade))
    }
}
