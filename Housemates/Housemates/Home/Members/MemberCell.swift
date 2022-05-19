//
//  MemberCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/2/22.
//

import UIKit

class MemberCell: UITableViewCell {

    
    @IBOutlet var memberView: UIView!
    
    @IBOutlet var memberNameLabel: UILabel!
    @IBOutlet var memberImage: UIImageView!
    @IBOutlet var memberPhoneLabel: UILabel!
    @IBOutlet var memberEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memberView.layer.cornerRadius = 13
        memberView.layer.shadowColor = UIColor.black.cgColor
        memberView.layer.shadowOpacity = 0.3
        memberView.layer.shadowOffset = .zero
        memberView.layer.shadowRadius = 5
        
        memberImage.layer.cornerRadius = memberImage.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
