//
//  RuleCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/15/22.
//

import UIKit

class RuleCell: UITableViewCell {

    
    @IBOutlet weak var ruleTitle: UILabel!
    @IBOutlet weak var ruleDescription: UITextView!
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var unapproveButton: UIButton!
    var rule: rule?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
