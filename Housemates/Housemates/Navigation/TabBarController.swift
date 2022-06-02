//
//  TabBarController.swift
//  Housemates
//
//  Created by Jackson Tran on 5/12/22.
//

import UIKit

class TabBarController: UITabBarController {
    var choreList = [chore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chooses which set of screen as Your Home
        // House code exist -> HomeVC
        // House code not exist -> HomeslessVC
        if (currentUser?.house_code == nil) {
            viewControllers?.remove(at:0)
        } else {
            viewControllers?.remove(at:1)
        }
        
        // Saves user login upon restarting app
        UserDefaults.standard.set(currentUser?.email, forKey: "email")
        UserDefaults.standard.synchronize()
        
        
        let nc = self.viewControllers?[0] as? UINavigationController
        
        // setup list of housemates
        if (nc?.viewControllers[0] as? HomeVC) != nil {
            getHouseMembers()
        }
    }
}
