//
//  AddChoresVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/6/22.
//

import UIKit

class AddChoresVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var dateTopView: UIView!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var dateBottomView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var assignTopView: UIView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var parentVC: UIViewController?
    
    let dateFormatter = DateFormatter()
    let toDateFormatter = DateFormatter()
    var dateHidden = true
    var memberTableHidden = true

    var memberList = [user]()
    var selectedList = [Bool]()
    var isEditting = false
    var choreData: (chore: chore, assignees: [user])?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        setBottomBorder(textfield: titleTextField)
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 13
        descriptionTextView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        dateTopView.layer.cornerRadius = 13
        dateTopView.layer.borderWidth = 1
        dateTopView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        dateBottomView.layer.cornerRadius = 13
        dateBottomView.layer.borderWidth = 1
        dateBottomView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        assignTopView.layer.cornerRadius = 13
        assignTopView.layer.borderWidth = 1
        assignTopView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateBottomView.isHidden = true
        datePicker.layer.isHidden = true
        datePicker.minimumDate = date
        
        toDateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        
        if isEditting {
            if let chore = choreData?.chore {
                titleTextField.text = chore.name
                descriptionTextView.text = chore.description
                if descriptionTextView.text == "Add a Description" {
                    descriptionTextView.textColor = UIColor.lightGray
                }
                if let dateFromString = toDateFormatter.date(from: chore.due_date) {
                    datePicker.date = dateFromString
                    dateButton.setTitle(dateFormatter.string(from: dateFromString), for: .normal)
                }
            }
            addButton.setTitle("Done", for: .normal)
        } else {
            descriptionTextView.text = "Add a Description"
            descriptionTextView.textColor = UIColor.lightGray
            dateButton.setTitle(dateFormatter.string(from: date), for: .normal)
        }
        
        memberTableView.layer.cornerRadius = 13
        memberTableView.layer.borderWidth = 1
        memberTableView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.isHidden = true
        getHouseMembers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Add a Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        switch textField {
        case titleTextField:
            return count <= 45
        case descriptionTextView:
            return count <= 200
        default:
            return count <= 64
        }
    }
    
    @IBAction func onDateTouch(_ sender: Any) {
        self.dateHidden = !self.dateHidden
        UIView.animate(withDuration: 0.2) {
            self.dateBottomView.isHidden = !self.dateBottomView.isHidden
            self.datePicker.layer.isHidden = !self.datePicker.layer.isHidden
        }
    }
    
    @IBAction func onDateChange(_ sender: Any) {
        dateButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAssign(_ sender: Any) {
        memberTableHidden = !memberTableHidden
        UIView.animate(withDuration: 0.2) {
            self.memberTableView.isHidden = !self.memberTableView.isHidden
        }
    }
    
    @IBAction func onAddChore(_ sender: Any) {
        if (titleTextField.text!.isEmpty) {
            errorAddChore()
            return
        }
        
        let templateDateFormatter = DateFormatter()

        templateDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //templateDateFormatter.dateFormat = "MMMM dd yyyy hh:mma"
        let date = templateDateFormatter.string(from: datePicker.date)
        
        if isEditting, let chore = choreData?.chore{
            editChore(chore_id: chore.id, name: titleTextField.text!, desc: descriptionTextView.text!, due_date: date, house_code: currentUser!.house_code!)
        } else {
            createChore(name: titleTextField.text!, desc: descriptionTextView.text!, due_date: date, house_code: currentUser!.house_code!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func errorAddChore() {
        let alert = UIAlertController(title: "Title Field Required", message: "The Title field is empty. Please enter a viable chore title.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddChoreMemberCell") as! AddChoreMemberCell
        
        let member = self.memberList[indexPath.row]
        cell.memberName.text = member.first_name + " " + member.last_name
        if self.selectedList[indexPath.row] {
            cell.memberName.textColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
            cell.memberImage.layer.borderWidth = 2
            cell.memberImage.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        }
        setProfilePic(member.email, imageView: cell.memberImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddChoreMemberCell
        self.selectedList[indexPath.row] = !self.selectedList[indexPath.row]
        
        if self.selectedList[indexPath.row] {
            cell.memberName.textColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
            cell.memberImage.layer.borderWidth = 2
            cell.memberImage.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        } else {
            cell.memberName.textColor = .black
            cell.memberImage.layer.borderWidth = 0
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        let dateHeight = dateHidden ? 0 : (328 + 8)
        self.stackHeight?.constant = (memberTableHidden ? 0 : self.memberTableView.contentSize.height + 8) + 128 + CGFloat(dateHeight)
        self.tableHeight?.constant = memberTableHidden ? 0 : self.memberTableView.contentSize.height
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
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:multiUserResponse
            do {
                result = try JSONDecoder().decode(multiUserResponse.self, from: data!)
                
                if result.code != 200 {
                    return
                }
                self.memberList = result.data ?? []
                for member in self.memberList {
                    if self.isEditting, let assignees = self.choreData?.assignees {
                        if assignees.contains(where: {$0.id == member.id}) {
                            self.selectedList.append(true)
                        } else {
                            self.selectedList.append(false)
                        }
                    } else {
                        self.selectedList.append(false)
                    }
                }
                DispatchQueue.main.async {
                    self.memberTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func createChore(name: String, desc: String, due_date: String, house_code: String) {
        let url = URL(string: "http://127.0.0.1:8080/create_chore")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        var list_id_selected = [Int]()
        for i in 0..<selectedList.count {
            if selectedList[i] {
                list_id_selected.append(self.memberList[i].id)
            }
        }
        let parameters: [String: Any] = [
            "name": name,
            "desc": desc,
            "due_date": due_date,
            "house_code": house_code,
            "assignees": list_id_selected
        ]
        print(parameters)
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:chorePostResponse
            do {
                result = try JSONDecoder().decode(chorePostResponse.self, from: data!)
                print(result)
                if result.code != 200 {
                    print(result)
                    return
                }
                DispatchQueue.main.async {
                    if let parentVC = self.parentVC as? ChoresVC{
                        parentVC.getChoreByHouseCode(houseCode: currentUser!.house_code!)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    func editChore(chore_id: Int, name: String, desc: String, due_date: String, house_code: String) {
        let url = URL(string: "http://127.0.0.1:8080/edit_chore")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        
        var list_id_selected = [Int]()
        for i in 0..<selectedList.count {
            if selectedList[i] {
                list_id_selected.append(self.memberList[i].id)
            }
        }
        let parameters: [String: Any] = [
            "chore_id": chore_id,
            "name": name,
            "description": desc,
            "due_date": due_date,
            "house_code": house_code,
            "assignees": list_id_selected
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        print(list_id_selected)
        let dataTask = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            var result:postResponse
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data!)
                print(result)
                if result.code != 200 {
                    print(result)
                    return
                }
                DispatchQueue.main.async {
                    self.updateParentChoreList()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func updateParentChoreList() {
        let date = toDateFormatter.string(from: datePicker.date)
        
        if let parentVC = self.parentVC as? ChoresVC {
            if let choreIndex = parentVC.assignedchoreList.firstIndex(where: {$0.id == choreData!.chore.id}) {
                if selectedList.contains(where: {$0 == true}) {
                    parentVC.assignedchoreList[choreIndex] = chore(id: choreData!.chore.id, name: titleTextField.text!, due_date: date, house_code: choreData!.chore.house_code, description: descriptionTextView.text)
                } else {
                    parentVC.assignedchoreList.remove(at: choreIndex)
                    parentVC.unassignedchoreList.append(chore(id: choreData!.chore.id, name: titleTextField.text!, due_date: date, house_code: choreData!.chore.house_code, description: descriptionTextView.text))
                }
            } else if let choreIndex = parentVC.unassignedchoreList.firstIndex(where: {$0.id == choreData!.chore.id}) {
                if selectedList.contains(where: {$0 == true}) {
                    parentVC.unassignedchoreList.remove(at: choreIndex)
                    parentVC.assignedchoreList.append(chore(id: choreData!.chore.id, name: titleTextField.text!, due_date: date, house_code: choreData!.chore.house_code, description: descriptionTextView.text))
                } else {
                    parentVC.unassignedchoreList[choreIndex] = chore(id: choreData!.chore.id, name: titleTextField.text!, due_date: date, house_code: choreData!.chore.house_code, description: descriptionTextView.text)
                }
            }
            parentVC.sortChoreList()
            parentVC.currentChoresTableView.reloadData()
            parentVC.unassignedChoresTableView.reloadData()
        } else if let parentVC = self.parentVC as? HomeVC{
            parentVC.loaded = 2
            parentVC.getChoreByUser(userID: String(currentUser!.id))
        }
    }
}
