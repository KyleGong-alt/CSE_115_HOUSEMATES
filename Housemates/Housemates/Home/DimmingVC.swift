//
//  DimmingVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/1/22.
//

import UIKit

// Dimming View for side bar animation
class DimmingVC: UIViewController {

    let dimmingTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        self.view.alpha = 0
        self.view.addGestureRecognizer(dimmingTap)
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        print("TAPPED")
    }
}
