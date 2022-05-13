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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currentChoresTableView.delegate = self
        currentChoresTableView.dataSource = self
        unassignedChoresTableView.delegate = self
        unassignedChoresTableView.dataSource = self
        
        setBottomBorder(label: currentChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        setBottomBorder(label: unassignedChoresLabel, height: 8, color: UIColor.white.cgColor)
        
        getChoreByHouseCode(houseCode: currentUser!.house_code!)
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
            cell.choreTime.text = chore.due_date
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChoreCell") as! YourChoreCell
            let chore = unassignedchoreList[indexPath.row] as chore
            cell.choreTitle.text = chore.name
            cell.choreDescription.text = chore.description
            cell.choreTime.text = chore.due_date
            return cell
        }
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
    
    @IBAction func onAddChore(_ sender: Any) {
        performSegue(withIdentifier: "segueAddChores", sender: nil)
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
                print(result)
                print(result.data?.count ?? 0)
                if ((result.data?.count ?? 0) != 0) {
                    self.assignedchoreList.append(chore)
                } else {
                    self.unassignedchoreList.append(chore)
                }
                DispatchQueue.main.async {
                    self.currentChoresTableView.reloadData()
                    self.unassignedChoresTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
