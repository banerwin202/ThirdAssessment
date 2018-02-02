//
//  PropertyTableViewCell.swift
//  ThirdAssessment
//
//  Created by Ban Er Win on 02/02/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
