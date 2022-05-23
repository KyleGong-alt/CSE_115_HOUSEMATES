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
    var choreAssigneesList = [[user]]()
    var toDateFormatter = DateFormatter()
    var printDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentChoresTableView.delegate = self
        currentChoresTableView.dataSource = self
        unassignedChoresTableView.delegate = self
        unassignedChoresTableView.dataSource = self
        
        setBottomBorder(label: currentChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        setBottomBorder(label: unassignedChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        toDateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        printDateFormatter.dateStyle = DateFormatter.Style.long
        printDateFormatter.timeStyle = DateFormatter.Style.short
        
        self.unassignedchoreList.sort(by: {toDateFormatter.date(from: $0.due_date)!.compare(toDateFormatter.date(from: $1.due_date)!) == .orderedAscending})
        self.assignedchoreList.sort(by: {toDateFormatter.date(from: $0.due_date)!.compare(toDateFormatter.date(from: $1.due_date)!) == .orderedAscending})
        for chore in assignedchoreList {
            getAssigneesChore(chore: chore)
        }
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
            
            let dateFromString: Date? = toDateFormatter.date(from: chore.due_date)
            cell.choreTime.text = printDateFormatter.string(from: dateFromString!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = unassignedchoreList[indexPath.row] as chore
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            let dateFromString: Date? = toDateFormatter.date(from: chore.due_date)
            cell.choreTime.text = printDateFormatter.string(from: dateFromString!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == currentChoresTableView) {
            performSegue(withIdentifier: "seguePickChore", sender: assignedchoreList[indexPath.row])
        } else {
            performSegue(withIdentifier: "seguePickChore", sender: unassignedchoreList[indexPath.row])
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePickChore" {
            let destinationVC = segue.destination as! ChoreHalfSheetVC
            destinationVC.sheetPresentationController?.detents = [.medium(), .large()]
            let chore = sender as! chore
            destinationVC.chore = chore
            destinationVC.parentVC = self
            let assignedIndex = assignedchoreList.firstIndex(where: {$0.id == chore.id })
            if assignedIndex != nil {
                destinationVC.assignees = choreAssigneesList[assignedIndex!]
                
            }
        } else if segue.identifier == "segueAddChores" {
            let destinationVC = segue.destination as! AddChoresVC
            destinationVC.currentUser = self.currentUser
            if let choreData = sender as? (chore: chore, assignees: [user]) {
                destinationVC.isEditting = true
                destinationVC.choreData = choreData
            }
            destinationVC.parentVC = self
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
    
    func getAssigneesChore(chore: chore){
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
                self.choreAssigneesList.append(result.data ?? [])
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

