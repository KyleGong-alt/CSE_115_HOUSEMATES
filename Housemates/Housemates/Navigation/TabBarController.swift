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
    var memberList = [user]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (currentUser?.house_code == nil) {
            viewControllers?.remove(at:0)
            
        } else {
            viewControllers?.remove(at:1)
        }
        UserDefaults.standard.set(currentUser?.email, forKey: "email")
        UserDefaults.standard.synchronize()
        
        let nc = self.viewControllers?[0] as? UINavigationController
        if let vc = nc?.viewControllers[0] as? HomeVC {
            vc.currentUser = self.currentUser
            self.getHouseMembers()
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
            destinationVC.memberList = memberList
        }
    }
    func getHouseMembers() {
        var components = URLComponents(string: "http://127.0.0.1:8080/get_house_members")!
        components.queryItems = [
            URLQueryItem(name: "house_code", value: currentUser?.house_code)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:multiUserResponse
            do {
                result = try JSONDecoder().decode(multiUserResponse.self, from: data!)
                
                if result.code != 200 {
                    return
                }
                
                self.memberList = result.data ?? []
                
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
