//
//  HomeViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var choresView: UIView!
    @IBOutlet weak var currentChoreLabel: UILabel!
    @IBOutlet weak var testChoreView: UIView!
    @IBOutlet weak var test2ChoreView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBottomBorder(label: currentChoreLabel)
        
        choresView.layer.cornerRadius = 13
        choresView.layer.shadowColor = UIColor.black.cgColor
        choresView.layer.shadowOpacity = 0.5
        choresView.layer.shadowOffset = .zero
        choresView.layer.shadowRadius = 10
        
        testChoreView.layer.cornerRadius = 13
        test2ChoreView.layer.cornerRadius = 13
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
