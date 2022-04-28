//
//  HomelessViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

class HomelessVC: UIViewController {
    
    @IBOutlet weak var addHouseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onAddHouse(_ sender: Any) {
        // Segue to add a house screen
        performSegue(withIdentifier: "segueToAddHouse", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
