//
//  ChoreHalfSheetVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/27/22.
//

import UIKit

// Chore half sheet when selecting a chore to view detail
class ChoreHalfSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var choreTitle: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var membersTableView: UITableView!
    @IBOutlet var membersView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var parentVC: UIViewController?
    var chore: chore!
    var assignees = [user]()
    var toDateFormatter = DateFormatter()
    var printDateFormatter = DateFormatter()
    var printTimeFormatter = DateFormatter()
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up progress loading view
        overrideUserInterfaceStyle = .light
        self.membersView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.membersView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.membersView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        loadingIndicator.isAnimating = true
        
        // Set delegate and datasource
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.isHidden = true
        
        // Initialize UI designs
        descriptionText.layer.cornerRadius = 13
        descriptionText.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        editButton.layer.cornerRadius = 13
        
        choreTitle.text = chore.name
        descriptionText.text = chore.description
        
        toDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        printDateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        printTimeFormatter.dateFormat = "hh:mm a"
        
        if let dateFromString = toDateFormatter.date(from: chore.due_date) {
            dateLabel.text = printDateFormatter.string(from: dateFromString)
            timeLabel.text = printTimeFormatter.string(from: dateFromString)
        }
    }
    
    // Check if data is done async loading
    func doneLoading() {
        membersTableView.reloadData()
        loadingIndicator.isAnimating = false
        membersTableView.isHidden = false
        
    }
    
    // Layout subview
    override func viewDidLayoutSubviews() {
        // add bottom border after subview auto layout from text
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: choreTitle.frame.height + 4, width: choreTitle.frame.width + 68, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        choreTitle.layer.addSublayer(bottomLine)
    }
    
    // Responds when view will appear
    override func viewWillAppear(_ animated: Bool) {
        getAssigneesYourChore(chore: chore)
    }
    
    // Returns number of rows in memberTableView based on number of assignees
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assignees.count
    }
    
    // Deques cell for each row in memberTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedMemberCell") as! AssignedMemberCell
        let member = assignees[indexPath.row]
        cell.memberName.text = member.first_name + " " + member.last_name
        setProfilePic(member.email, imageView: cell.memberPic)
        return cell
    }

    // On press check, remove chore from database
    @IBAction func onCheck(_ sender: Any) {
        deleteChore(chore: chore)
    }
    
    // On edit, sends user to edit chore
    @IBAction func onEdit(_ sender: Any) {
        self.dismiss(animated: true) {
            let choreData = (chore: self.chore, assignees: self.assignees)
            self.parentVC?.performSegue(withIdentifier: "segueAddChores", sender: choreData)
        }
    }
    
    // Get assignees base on chore
    func getAssigneesYourChore(chore: chore){
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
                
                if (result.code != 200) {
                    print(result)
                    return
                }
                
                self.assignees = result.data ?? []
                DispatchQueue.main.async {
                    self.doneLoading()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    // Request for deleting chore from database
    func deleteChore(chore: chore) {
        let url = URL(string: "http://127.0.0.1:8080/delete_chore")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "DELETE"
        let parameters: [String: Any] = [
            "chore_id": chore.id
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:postResponse
            do {
                guard let data = data else {
                    print("Server not connected!")
                    return
                }
                
                result = try JSONDecoder().decode(postResponse.self, from: data)
                
                if (result.code != 200) {
                    print(result)
                    return
                }
                
                DispatchQueue.main.async {
                    self.updateParentChoreList()
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    // Update parent chore list when delete chore
    func updateParentChoreList() {
        if let parentVC = self.parentVC as? ChoresVC {
            parentVC.viewWillAppear(true)
        } else if let parentVC = self.parentVC as? HomeVC{
            parentVC.loaded = 2
            parentVC.getChoreByUser(userID: String(currentUser!.id))
        }
    }
}
