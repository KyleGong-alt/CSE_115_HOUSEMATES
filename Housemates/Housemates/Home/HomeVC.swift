//
//  HomeViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var choresView: UIView!
    @IBOutlet weak var currentChoreLabel: UILabel!
    
    @IBOutlet weak var choreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBottomBorder(label: currentChoreLabel, height: 8, color: UIColor.white.cgColor)
        
        choresView.layer.cornerRadius = 13
        choresView.layer.shadowColor = UIColor.black.cgColor
        choresView.layer.shadowOpacity = 0.5
        choresView.layer.shadowOffset = .zero
        choresView.layer.shadowRadius = 10
        
        choreTableView.delegate = self
        choreTableView.dataSource = self
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case choreTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
                return cell
            
            default:
                return UITableViewCell()
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "seguePickChore", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePickChore" {
            let destinationVC = segue.destination as! ChoreHalfSheetVC
            destinationVC.sheetPresentationController?.detents = [.medium(), .large()]
        }
    }

}
