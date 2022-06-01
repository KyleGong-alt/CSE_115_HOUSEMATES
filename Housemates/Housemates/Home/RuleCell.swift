//
//  RuleCell.swift
//  Housemates
//
//  Created by Jackson Tran on 5/15/22.
//

import UIKit

class RuleCell: UITableViewCell {

    
    @IBOutlet weak var ruleTitle: UILabel!
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet var ruleDescription: UILabel!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var unapproveButton: UIButton!
    var rule: rule?
    var parentVC: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onApprove(_ sender: Any) {
        updateVote(user_id: currentUser!.id, rule_id: rule!.id, update_value: 1)
    }
    
    
    @IBAction func onDisapprove(_ sender: Any) {
        updateVote(user_id: currentUser!.id, rule_id: rule!.id, update_value: -1)
    }
    
    func updateVote(user_id: Int, rule_id: Int, update_value: Int) {
        let url = URL(string: "http://127.0.0.1:8080/update_house_rule_voted_num")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        
        let parameters: [String: Any] = [
            "user_id": user_id,
            "rule_id": rule_id,
            "update_value": update_value
        ]
        print(parameters)
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:postResponse
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data!)
                if result.code != 200 {
                    print(result)
                    return
                }
                DispatchQueue.main.async {
                    if let parentVC = self.parentVC as? HomeVC{
                        parentVC.loaded = 1
                        parentVC.getApprovedRules()
                        parentVC.getUserUnvotedRules()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
