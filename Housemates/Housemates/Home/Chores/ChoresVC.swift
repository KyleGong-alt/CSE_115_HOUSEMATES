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
    
    var choreList = [chore]()
    var unassignedchoreList = [chore]()
    var assignedchoreList = [chore]()
    var toDateFormatter = DateFormatter()
    var printDateFormatter = DateFormatter()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up loading progress view
        overrideUserInterfaceStyle = .light
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        loadingIndicator.isAnimating = true
        
        
        // Set delegates and datasource
        currentChoresTableView.delegate = self
        currentChoresTableView.dataSource = self
        unassignedChoresTableView.delegate = self
        unassignedChoresTableView.dataSource = self
        
        
        // Set up UI designs
        setBottomBorder(label: currentChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        setBottomBorder(label: unassignedChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        currentChoresTableView.isHidden = true
        unassignedChoresTableView.isHidden = true
        currentChoresLabel.isHidden = true
        unassignedChoresLabel.isHidden = true
        
        currentChoresTableView.estimatedRowHeight = 100
        currentChoresTableView.rowHeight = UITableView.automaticDimension
        unassignedChoresTableView.estimatedRowHeight = 100
        unassignedChoresTableView.rowHeight = UITableView.automaticDimension
        
        toDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        printDateFormatter.dateStyle = DateFormatter.Style.long
        printDateFormatter.timeStyle = DateFormatter.Style.short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Change tab bar color to green tint when view appearing
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
        tabBarController?.tabBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
        
        // Get chore data
        getChoreByHouseCode(houseCode: currentUser!.house_code!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Change tab bar color back to tan tint when view disappear
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 255/255, green: 252/255, blue: 230/255, alpha: 1)
        tabBarController?.tabBar.tintColor = UIColor.init(red: 69/255, green: 125/255, blue: 122/255, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 252/255, blue: 230/255, alpha: 1)
    }
    
    // Check if data is done async loading
    func doneLoading() {
        if (choreList.count == unassignedchoreList.count + assignedchoreList.count) {
            loadingIndicator.isAnimating = false
            sortChoreList()
            self.currentChoresTableView.reloadData()
            self.unassignedChoresTableView.reloadData()
            self.currentChoresTableView.isHidden = false
            self.unassignedChoresTableView.isHidden = false
            currentChoresLabel.isHidden = false
            unassignedChoresLabel.isHidden = false
        }
    }
    
    // Sort chore list base on date
    func sortChoreList() {
        self.unassignedchoreList.sort(by: {toDateFormatter.date(from: $0.due_date)!.compare(toDateFormatter.date(from: $1.due_date)!) == .orderedAscending})
        self.assignedchoreList.sort(by: {toDateFormatter.date(from: $0.due_date)!.compare(toDateFormatter.date(from: $1.due_date)!) == .orderedAscending})
    }

    // Returns number of row for specified tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == currentChoresTableView) {
            return assignedchoreList.count
        } else {
            return unassignedchoreList.count
        }
    }
    
    // Deque which cell for specified tableView
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
    
    // Action when selected row for specified tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == currentChoresTableView) {
            performSegue(withIdentifier: "seguePickChore", sender: assignedchoreList[indexPath.row])
        } else {
            performSegue(withIdentifier: "seguePickChore", sender: unassignedchoreList[indexPath.row])
        }
        
    }
    
    // Preparation for different segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePickChore" {
            let destinationVC = segue.destination as! ChoreHalfSheetVC
            destinationVC.sheetPresentationController?.detents = [.medium(), .large()]
            let chore = sender as! chore
            destinationVC.chore = chore
            destinationVC.parentVC = self
        } else if segue.identifier == "segueAddChores" {
            let destinationVC = segue.destination as! AddChoresVC
            if let choreData = sender as? (chore: chore, assignees: [user]) {
                destinationVC.isEditting = true
                destinationVC.choreData = choreData
            }
            destinationVC.parentVC = self
        }
    }
    
    // User press Add
    @IBAction func onAddChore(_ sender: Any) {
        performSegue(withIdentifier: "segueAddChores", sender: nil)
    }
    
    // Get chore with house code request
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
                guard let data = data else {
                    print("Server not connected!")
                    return
                }
                result = try JSONDecoder().decode(choreResponse.self, from: data)
                self.choreList = result.data ?? []
                self.unassignedchoreList.removeAll()
                self.assignedchoreList.removeAll()
                for chore in self.choreList {
                    self.getAssignees(chore: chore)
                }
                DispatchQueue.main.async {
                    self.doneLoading()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    // Get assignees base on chore
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
                guard let data = data else {
                    print("Server not connected!")
                    return
                }
                
                result = try JSONDecoder().decode(assigneeResponse.self, from: data)
                if ((result.data?.count ?? 0) != 0) {
                    self.assignedchoreList.append(chore)
                } else {
                    self.unassignedchoreList.append(chore)
                }
                DispatchQueue.main.async {
                    self.doneLoading()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

