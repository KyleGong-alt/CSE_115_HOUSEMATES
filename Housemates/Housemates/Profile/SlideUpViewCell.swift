//
//  SlideUpViewCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/20/22.
//

import UIKit

class SlideUpViewCell: UITableViewCell {

    lazy var backView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        return view
    } ()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 16, y: 10, width: 30, height: 30))
        return view
    }()
    
    lazy var labelView: UILabel = {
        let view = UILabel(frame:CGRect(x: 60, y: 10, width: self.frame.width - 75, height: 30))
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(iconView)
        backView.addSubview(labelView)
        // Configure the view for the selected state
    }

}
