//
//  HomelessViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

// Your Home VC if user is not part of a house
class HomelessVC: UIViewController {
    
    @IBOutlet weak var addHouseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addHouseButton.layer.cornerRadius = 13
    }
    
    // Segue to add house
    @IBAction func onAddHouse(_ sender: Any) {
        performSegue(withIdentifier: "segueAddHouse", sender: nil)
    }
    
}
