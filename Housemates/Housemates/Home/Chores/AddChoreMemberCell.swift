//
//  AddChoreMemberCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/17/22.
//

import UIKit

class AddChoreMemberCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        memberImage.layer.cornerRadius = memberImage.frame.height/2
        // Configure the view for the selected state
    }
}
