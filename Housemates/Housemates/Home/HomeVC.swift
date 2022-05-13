//
//  HomeViewController.swift
//  Housemates
//
//  Created by Jackson Tran on 4/26/22.
//

import UIKit

struct chore: Codable {
    let id: Int
    let name: String
    let due_date: String
    let house_code: String
    let description: String?
}

struct choreResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [chore]?
}

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var choresView: UIView!
    @IBOutlet weak var currentChoreLabel: UILabel!
    
    @IBOutlet var choreNextButton: UIButton!
    @IBOutlet weak var choreTableView: UITableView!
    
    var currentUser: user?

    var choreList = [chore]()
    
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
        
        //let leftSwipe = UISwipeGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>)
        //print(currentUser)
        getChoreByUser(userID: String(currentUser!.id))
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(choreList)
        return choreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case choreTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = choreList[indexPath.row] as chore
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
            var dateFromString: Date? = dateFormatter.date(from: chore.due_date)
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            cell.choreTime.text = chore.due_date
            return cell
            
            default:
                return UITableViewCell()
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "seguePickChore", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePickChore" {
            let destinationVC = segue.destination as! ChoreHalfSheetVC
            destinationVC.sheetPresentationController?.detents = [.medium(), .large()]
            let indexPath = sender as! IndexPath
            let chore = choreList[indexPath.row] as chore
            destinationVC.chore = chore
            
        } else if segue.identifier == "segueMembers" {
            let destinationVC = segue.destination as! MembersVC
            destinationVC.currentUser = self.currentUser
        } else if segue.identifier == "segueAllChore" {
            let destinationVC = segue.destination as! ChoresVC
            destinationVC.currentUser = self.currentUser
        }
    }

    @IBAction func onChoreNext(_ sender: Any) {
        performSegue(withIdentifier: "segueAllChore", sender: nil)
    }
    
    @IBAction func onViewMembers(_ sender: Any) {
        performSegue(withIdentifier: "segueMembers", sender: nil)
    }
    
    func getChoreByUser(userID: String) {
        var components = URLComponents(string: "http://127.0.0.1:8080/get_chores_by_user")!
        components.queryItems = [
            URLQueryItem(name: "user_id", value: userID)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:choreResponse
            do {
                result = try JSONDecoder().decode(choreResponse.self, from: data!)
                //print(result)
                self.choreList = result.data  ?? []
                DispatchQueue.main.async {
                    self.choreTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

