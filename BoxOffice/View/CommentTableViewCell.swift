//
//  CommentTableViewCell.swift
//  BoxOffice
//
//  Created by hyerikim on 15/12/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var starImageViews: [UIImageView]!    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        initStarImageViews()
    }
    
    private func initStarImageViews() {
        for i in stride(from: 0, to: 5, by: 1) {
            starImageViews[i].image = UIImage(named: "ic_star_large")
        }
    }
}
