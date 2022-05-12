//
//  ChoresVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import UIKit

class ChoresVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var currentChoresLabel: UILabel!
    @IBOutlet var unassignedChoresLabel: UILabel!
    
    @IBOutlet var currentChoresTableView: UITableView!
    @IBOutlet var unassignedChoresTableView: UITableView!
    
    var currentUser: user?
    
    var choreList = [chore]()
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            print(data, response)
            var result:choreResponse
            do {
                result = try JSONDecoder().decode(choreResponse.self, from: data!)
                //print(result)
                self.choreList = result.data  ?? []
                print(self.choreList)
//                DispatchQueue.main.async {
//                    self.choreTableView.reloadData()
//                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
