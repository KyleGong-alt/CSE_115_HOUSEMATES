//
//  ChoresVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import UIKit

class ChoresVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var currentChoresLabel: UILabel!
    @IBOutlet var unassignedChoresLabel: UILabel!
    
    @IBOutlet var currentChoresTableView: UITableView!
    @IBOutlet var unassignedChoresTableView: UITableView!
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
        return cell
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
    @IBAction func onReturn(_ sender: Any) {
        performSegue(withIdentifier: "segueCloseChores", sender: nil)
    }
    
    @IBAction func onAddChore(_ sender: Any) {
        performSegue(withIdentifier: "segueAddChores", sender: nil)
    }
    
}
