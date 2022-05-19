//
//  TabBarController.swift
//  Housemates
//
//  Created by Jackson Tran on 5/12/22.
//

import UIKit

class TabBarController: UITabBarController {

    var currentUser: user?
    var choreList = [chore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testing = user(id: 1, first_name: "test_fn", last_name: "carrera", house_code: "AKZXCOPQ", mobile_number: "1234567890", email: "test@ucsc.edu", password: "password")
        //currentUser = testing
        print(currentUser)
        if (currentUser?.house_code == nil) {
            viewControllers?.remove(at:0)
            
        } else {
            viewControllers?.remove(at:1)
        }
        let nc1 = self.viewControllers?[0] as? UINavigationController
        if let vc1 = nc1?.viewControllers[0] as? HomeVC {
            vc1.currentUser = self.currentUser
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMembers" {
            let destinationVC = segue.destination as! MembersVC
            destinationVC.currentUser = currentUser
        }
    }
    

    

}
