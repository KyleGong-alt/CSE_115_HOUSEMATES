//
//  MembersVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/1/22.
//

import UIKit

class MembersVC: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var houseCodeLabel: UILabel!
    @IBOutlet var memberTableView: UITableView!
    
    var currentUser: user?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        houseCodeLabel.layer.masksToBounds = true
        houseCodeLabel.layer.cornerRadius = 13
        houseCodeLabel.layer.borderWidth = 1
        houseCodeLabel.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    

    @IBAction func onClose(_ sender: Any) {
        performSegue(withIdentifier: "segueCloseRightNav", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCloseRightNav" {
            let destinationVC = segue.destination as! HomeVC
            destinationVC.currentUser = self.currentUser
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as! MemberCell
        return cell
    }

}
