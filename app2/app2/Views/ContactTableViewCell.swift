//
//  ContactTableViewCell.swift
//  app2
//
//  Created by 최우태 on 2023/08/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
