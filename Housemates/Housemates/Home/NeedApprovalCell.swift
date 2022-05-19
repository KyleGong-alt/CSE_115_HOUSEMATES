//
//  NeedApprovalTitleCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/15/22.
//

import UIKit

class NeedApprovalCell: UITableViewCell {
    
    
    @IBOutlet var ruleDescription: UILabel!
    @IBOutlet var container: UIView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var xButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
