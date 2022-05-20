//
//  HomelessViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

class HomelessVC: UIViewController {
    
    var currentUser: user?
    
    @IBOutlet weak var addHouseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addHouseButton.layer.cornerRadius = 13
    }
    
    @IBAction func onAddHouse(_ sender: Any) {
        performSegue(withIdentifier: "segueAddHouse", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAddHouse" {
            let destinationNC =  segue.destination as! UINavigationController
            let destinationVC = destinationNC.viewControllers[0] as? AddHouseVC
            destinationVC?.currentUser = self.currentUser
        }
    }
    
}
