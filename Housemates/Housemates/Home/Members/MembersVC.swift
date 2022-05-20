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
    
    var memberList = [user]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        getHouseMembers()
    }

    @IBAction func onClose(_ sender: Any) {
        performSegue(withIdentifier: "segueCloseRightNav", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCloseRightNav" {
            let destinationVC = segue.destination as! TabBarController
            destinationVC.currentUser = self.currentUser
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as! MemberCell
        
        let user = self.memberList[indexPath.row]
        cell.memberNameLabel.text = user.first_name + " " + user.last_name
        cell.memberEmailLabel.text = user.email
        cell.memberPhoneLabel.text = format(with: "(XXX) XXX-XXX", phone: user.mobile_number)
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
    
    func getHouseMembers() {
        var components = URLComponents(string: "http://127.0.0.1:8080/get_house_members")!
        components.queryItems = [
            URLQueryItem(name: "house_code", value: currentUser?.house_code)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore.init(value: 0)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:multiUserResponse
            do {
                result = try JSONDecoder().decode(multiUserResponse.self, from: data!)
                
                if result.code != 200 {
                    semaphore.signal()
                    return
                }
                
                self.memberList = result.data ?? []
                DispatchQueue.main.async {
                    self.memberTableView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
    }
}
