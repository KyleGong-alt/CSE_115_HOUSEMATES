//
//  ChoresVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import UIKit

struct assigneeResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [user]?
}


class ChoresVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var currentChoresLabel: UILabel!
    @IBOutlet var unassignedChoresLabel: UILabel!
    
    @IBOutlet var currentChoresTableView: UITableView!
    @IBOutlet var unassignedChoresTableView: UITableView!
    
    var currentUser: user?
    
    var unassignedchoreList = [chore]()
    var assignedchoreList = [chore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currentChoresTableView.delegate = self
        currentChoresTableView.dataSource = self
        unassignedChoresTableView.delegate = self
        unassignedChoresTableView.dataSource = self
        
        setBottomBorder(label: currentChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        setBottomBorder(label: unassignedChoresLabel, height: 8, color: UIColor.white.cgColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
        tabBarController?.tabBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == currentChoresTableView) {
            return assignedchoreList.count
        } else {
            return unassignedchoreList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == currentChoresTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = assignedchoreList[indexPath.row] as chore
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            cell.choreTime.text = chore.due_date
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = unassignedchoreList[indexPath.row] as chore
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            cell.choreTime.text = chore.due_date
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "seguePickChore", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePickChore" {
            let destinationVC = segue.destination as! ChoreHalfSheetVC
            destinationVC.sheetPresentationController?.detents = [.medium(), .large()]
        } else {
            //navigationController?.pushViewController(segue.destination, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 255/255, green: 252/255, blue: 230/255, alpha: 1)
        tabBarController?.tabBar.tintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 252/255, blue: 230/255, alpha: 1)
    }
    
    @IBAction func onAddChore(_ sender: Any) {
        performSegue(withIdentifier: "segueAddChores", sender: nil)
    }
}
