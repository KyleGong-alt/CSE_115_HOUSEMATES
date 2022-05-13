//
//  DimmingVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/1/22.
//

import UIKit

class DimmingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimmingTap))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder)
        
    }
    
    @objc func dimmingTap(sender: UITapGestureRecognizer) {
        print("TAPPED")
    }
    

}
