//
//  ChoreHalfSheetVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/27/22.
//

import UIKit

class ChoreHalfSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var choreTitle: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var membersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        setBottomBorder(label: choreTitle, height: 8, color: UIColor.black.cgColor)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedMemberCell") as! AssignedMemberCell
        return cell
    }

}
