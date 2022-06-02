//
//  YourChoreCell.swift
//  Housemates
//
//  Created by Jackson Tran on 4/27/22.
//

import UIKit

// Chore cell for HomeVC
class YourChoreCell: UITableViewCell {
   
    @IBOutlet var choreView: UIView!
    @IBOutlet weak var choreTitle: UILabel!
    @IBOutlet weak var choreDescription: UILabel!
    @IBOutlet weak var choreTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choreView.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
