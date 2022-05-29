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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        houseCodeLabel.text = currentUser?.house_code
        houseCodeLabel.layer.masksToBounds = true
        houseCodeLabel.layer.cornerRadius = 13
        houseCodeLabel.layer.borderWidth = 1
        houseCodeLabel.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        houseCodeLabel.addGestureRecognizer(longPress)
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }

    @IBAction func onClose(_ sender: Any) {
        performSegue(withIdentifier: "segueCloseRightNav", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCloseRightNav" {
            let destinationVC = segue.destination as! TabBarController
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as! MemberCell
        
        let user = memberList[indexPath.row]
        cell.memberNameLabel.text = user.first_name + " " + user.last_name
        cell.memberEmailLabel.text = user.email
        cell.memberPhoneLabel.text = format(with: "(XXX) XXX-XXXX", phone: user.mobile_number)
        return cell
        
    }
    
    @objc func handleTap(_ sender: UILongPressGestureRecognizer? = nil) {
        //Set the default sharing message.
        //Set the link to share.
        if let message = currentUser?.house_code
        {
            let objectsToShare = [message] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLeaveHouse(_ sender: Any) {
        let url = URL(string: "http://127.0.0.1:8080/leave_house")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        guard let _ = currentUser?.id else {return}
        
        let parameters: [String: Any] = [
            "user_id": String(currentUser!.id),
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: postResponse
            guard let data = data else {
                print("FAILED TO LEAVE HOUSE")
                return
            }
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data)
                if (result.code != 200) {
                    return
                }
                let updatedUser = user(id: currentUser!.id, first_name: currentUser!.first_name, last_name: currentUser!.last_name, house_code: nil, mobile_number: currentUser!.mobile_number, email: currentUser!.email, password: currentUser!.password)
                currentUser = updatedUser
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueCloseRightNav", sender: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
