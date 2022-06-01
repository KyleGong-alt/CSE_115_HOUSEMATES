//
//  EditProfileVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/24/22.
//

import UIKit

class EditProfileVC: UIViewController, UITextFieldDelegate{

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var firstTextField: UITextField!
    
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var secondTextField: UITextField!
    var editType: String!
    var parentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        secondLabel.isHidden = true
        secondTextField.isHidden = true
        switch editType {
        case "first_name":
            navigationBar.topItem?.title = "Edit First Name"
            firstLabel.text = "First Name"
            firstTextField.placeholder = "First Name"
            return
        case "last_name":
            navigationBar.topItem?.title = "Edit Last Name"
            firstLabel.text = "Last Name"
            firstTextField.placeholder = "Last Name"
            return
        case "email":
            navigationBar.topItem?.title = "Edit Email"
            firstLabel.text = "Email"
            firstTextField.placeholder = "Email"
            return
        case "phone":
            navigationBar.topItem?.title = "Edit Phone Number"
            firstLabel.text = "Phone Number"
            firstTextField.placeholder = "Phone Number"
            firstTextField.keyboardType = .numberPad
            return
        case "password":
            navigationBar.topItem?.title = "Edit Password"
            firstLabel.text = "Current Password"
            firstTextField.placeholder = "Current Password"
            secondLabel.isHidden = false
            secondTextField.isHidden = false
            secondLabel.text = "New Password"
            secondTextField.placeholder = "New Password"
            return
        default:
            return
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 32
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        if !checkValidField() {
            return
        }
        switch editType {
        case "first_name":
            updateUser(email: currentUser!.email, first_name: firstTextField.text!, last_name: currentUser!.last_name, password: currentUser!.password, mobile_number: currentUser!.mobile_number)
            return
        case "last_name":
            updateUser(email: currentUser!.email, first_name: currentUser!.first_name, last_name: firstTextField.text!, password: currentUser!.password, mobile_number: currentUser!.mobile_number)
            return
        case "email":
            updateUser(email: firstTextField.text!, first_name: currentUser!.first_name, last_name: currentUser!.last_name, password: currentUser!.password, mobile_number: currentUser!.mobile_number)
            return
        case "phone":
            updateUser(email: currentUser!.email, first_name: currentUser!.first_name, last_name: currentUser!.last_name, password: currentUser!.password, mobile_number: firstTextField.text!)
            return
        case "password":
            updateUser(email: currentUser!.email, first_name: currentUser!.first_name, last_name: currentUser!.last_name, password: secondTextField.text!, mobile_number: currentUser!.mobile_number)
            return
        default:
            return
        }
    }
    
    func checkValidField() -> Bool{
        switch editType {
        case "phone":
            if !isValidPhone(firstTextField.text!) {
                let alert = UIAlertController(title: "Invalid Phone Input", message: "The phone number you inputted is invalid. Please try again.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        case "email":
            if !isValidEmail(firstTextField.text!) {
                let alert = UIAlertController(title: "Invalid Email Input", message: "The email address you inputted is invalid. Please try again.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        case "password":
            if firstTextField.text! != currentUser?.password {
                let alert = UIAlertController(title: "Password Not Match", message: "The password you inputted does not match the password in the server. Please try again.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                if secondTextField.text!.isEmpty {
                    let alert = UIAlertController(title: "Empty Field(s)", message: "One or more fields are empty. Please fill in the fields.", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

                    self.present(alert, animated: true, completion: nil)
                    return false
                }
                return true
            }
        default:
            if firstTextField.text!.isEmpty {
                let alert = UIAlertController(title: "Empty Field", message: "A required field is empty. Please fill in the field.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                return false
            }
            return true
        }
    }
    func updateUser(email: String, first_name: String, last_name: String, password: String, mobile_number: String) {
        let url = URL(string: "http://127.0.0.1:8080/update_user")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        
        let parameters: [String: Any] = [
            "email": email,
            "first_name": first_name,
            "last_name": last_name,
            "password": password,
            "mobile_number": mobile_number
        ]
        print(parameters)
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:postResponse
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data!)
                print(result)
                if result.code != 200 {
                    print(result)
                    return
                }
                DispatchQueue.main.async {
                    currentUser = user(id: currentUser!.id, first_name: first_name, last_name: last_name, house_code: currentUser!.house_code, mobile_number: mobile_number, email: email, password: password)
                    getHouseMembers()
                    if let parentVC = self.parentVC as? profileVC{
                        parentVC.viewDidLoad()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
