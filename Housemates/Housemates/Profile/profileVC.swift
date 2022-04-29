//
//  profileVC.swift
//  Housemates
//
//  Created by Luciano Villacrucis on 4/28/22.
//

import UIKit

class profileVC: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var logoutButton: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.bounds.width/2

        // Do any additional setup after loading the view.
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
