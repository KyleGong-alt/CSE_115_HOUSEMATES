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
        if (currentUser?.house_code == nil) {
            viewControllers?.remove(at:0)
            
        } else {
            viewControllers?.remove(at:1)
        }
        
        let nc = self.viewControllers?[0] as? UINavigationController
        if let vc = nc?.viewControllers[0] as? HomeVC {
            vc.currentUser = self.currentUser
        } else if let vc = nc?.viewControllers[0] as? HomelessVC {
            vc.currentUser = self.currentUser
        }
        
        let nc2 = self.viewControllers?[2] as? UINavigationController
        
        if let vc = nc2?.viewControllers[0] as? profileVC {
            vc.currentUser = self.currentUser
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc private func swipeGesture(swipe: UISwipeGestureRecognizer) {
        print(swipe.direction)
        switch swipe.direction {
        case .left:
            if selectedIndex > 0 {
                self.selectedIndex = self.selectedIndex - 1
            }
            break
        case .right:
            if selectedIndex < 3 {
                self.selectedIndex = self.selectedIndex + 1
            }
            break
        default:
            break
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMembers" {
            let destinationVC = segue.destination as! MembersVC
            destinationVC.currentUser = currentUser
        }
    }
}
