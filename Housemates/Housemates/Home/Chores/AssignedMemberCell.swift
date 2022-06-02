//
//  AssignedMemberCell.swift
//  Housemates
//
//  Created by Jackson Tran on 4/27/22.
//

import UIKit

// Assigned member cell for ChoreHalfSheetVC
class AssignedMemberCell: UITableViewCell {

    @IBOutlet var memberName: UILabel!
    @IBOutlet var memberPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memberPic.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
