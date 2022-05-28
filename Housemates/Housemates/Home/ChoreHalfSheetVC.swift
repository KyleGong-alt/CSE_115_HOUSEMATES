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
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var exButton: UIButton!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var membersTableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    
    var parentVC: UIViewController?
    var chore: chore!
    var assignees = [user]()
    var toDateFormatter = DateFormatter()
    var printDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        setBottomBorder(label: choreTitle, height: 4, color: UIColor.black.cgColor)
        descriptionText.layer.cornerRadius = 13
        descriptionText.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        choreTitle.text = chore.name
        descriptionText.text = chore.description
        
        toDateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        printDateFormatter.dateStyle = DateFormatter.Style.long
        printDateFormatter.timeStyle = DateFormatter.Style.short
        
        let dateFromString: Date? = toDateFormatter.date(from: chore.due_date)
        dateLabel.text = printDateFormatter.string(from: dateFromString!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assignees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedMemberCell") as! AssignedMemberCell
        cell.memberName.text = assignees[indexPath.row].first_name + " " + assignees[indexPath.row].last_name
        return cell
    }
    
    func animateCheck() {
        let option: UIView.AnimationOptions = [.curveEaseIn, .transitionCrossDissolve]
        UIView.animate(withDuration: 0.5, delay: 0, options: option, animations: {
            print("HELLO")
            self.checkButton.setImage(nil, for: .normal)
            self.checkButton.frame.origin.x -= 20
        }, completion: nil)
    }

    @IBAction func onCheck(_ sender: Any) {
        animateCheck()
    }
    @IBAction func onEdit(_ sender: Any) {
        self.dismiss(animated: true) {
            let choreData = (chore: self.chore, assignees: self.assignees)
            self.parentVC?.performSegue(withIdentifier: "segueAddChores", sender: choreData)
        }
    }
}
