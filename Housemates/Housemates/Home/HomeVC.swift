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
    
    @IBOutlet var choreNextButton: UIButton!
    @IBOutlet weak var choreTableView: UITableView!
    @IBOutlet weak var ruleTableView: UITableView!
    @IBOutlet var rulesView: UIView!
    @IBOutlet var ruleTitleLabel: UILabel!
    @IBOutlet var addRuleButton: UIButton!
    var currentUser: user?

    var choreList = [chore]()
    var unassignedchoreList = [chore]()
    var assignedchoreList = [chore]()
    var toDateFormatter = DateFormatter()
    var printDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBottomBorder(label: currentChoreLabel, height: 8, color: UIColor.white.cgColor)
        setBottomBorder(label: ruleTitleLabel, height: 8, color: UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor)
        
        choresView.layer.cornerRadius = 13
        choresView.layer.shadowColor = UIColor.black.cgColor
        choresView.layer.shadowOpacity = 0.5
        choresView.layer.shadowOffset = .zero
        choresView.layer.shadowRadius = 10
        
        ruleTableView.delegate = self
        ruleTableView.dataSource = self
        choreTableView.delegate = self
        choreTableView.dataSource = self
        
        rulesView.layer.cornerRadius = 13
        rulesView.layer.shadowColor = UIColor.black.cgColor
        rulesView.layer.shadowOpacity = 0.3
        rulesView.layer.shadowOffset = .zero
        rulesView.layer.shadowRadius = 10
        ruleTableView.layer.cornerRadius = 13
        
        addRuleButton.layer.cornerRadius = 40/2
        
        toDateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        printDateFormatter.dateStyle = DateFormatter.Style.long
        printDateFormatter.timeStyle = DateFormatter.Style.short
        getChoreByUser(userID: String(currentUser!.id))
        getChoreByHouseCode(houseCode: currentUser!.house_code!)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case choreTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = choreList[indexPath.row] as chore
            let dateFromString: Date? = toDateFormatter.date(from: chore.due_date)
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            cell.choreTime.text = printDateFormatter.string(from: dateFromString!)
            return cell
        case ruleTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell") as! RuleCell
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
        } else if segue.identifier == "segueAllChore" {
            let destinationVC = segue.destination as! ChoresVC
            destinationVC.currentUser = self.currentUser
            destinationVC.unassignedchoreList = self.unassignedchoreList
            destinationVC.assignedchoreList = self.assignedchoreList
        }
    }
    
    @IBAction func onChoreNext(_ sender: Any) {
        performSegue(withIdentifier: "segueAllChore", sender: nil)
    }
    
    @IBAction func onViewMembers(_ sender: Any) {
        self.tabBarController?.performSegue(withIdentifier: "segueMembers", sender: nil)
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
        let semaphore = DispatchSemaphore.init(value: 0)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:choreResponse
            do {
                result = try JSONDecoder().decode(choreResponse.self, from: data!)
                //print(result)
                self.choreList = result.data  ?? []
                DispatchQueue.main.async {
                    self.choreTableView.reloadData()
                    self.ruleTableView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
    }
    func getChoreByHouseCode(houseCode: String) {
        var components = URLComponents(string: "http://127.0.0.1:8080/get_chores_by_house_code")!
        components.queryItems = [
            URLQueryItem(name: "house_code", value: houseCode)
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
                let choreList = result.data ?? []
                for chore in choreList {
                    self.getAssignees(chore: chore)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func getAssignees(chore: chore){
        var components = URLComponents(string: "http://127.0.0.1:8080/get_assignees")!
        components.queryItems = [
            URLQueryItem(name: "chore_id", value: String(chore.id))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:assigneeResponse
            do {
                result = try JSONDecoder().decode(assigneeResponse.self, from: data!)
                if ((result.data?.count ?? 0) != 0) {
                    self.assignedchoreList.append(chore)
                } else {
                    self.unassignedchoreList.append(chore)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

