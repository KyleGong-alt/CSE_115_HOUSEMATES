//
//  PasswordVC.swift
//  Housemates
//
//  Created by Luciano Villacrucis on 4/19/22.
//

import UIKit



class PasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var phoneNumber: String!
    
    var user: user?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doneButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        
        passwordTextField.delegate = self
        setBottomBorder(textfield: passwordTextField)
        
    }
    
    // End text editing when tapping screen other than textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Disable signInButton if emailTextField or passwordTextField is empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (!(passwordTextField.text?.count == 0)) {
            doneButton.isUserInteractionEnabled = true
            doneButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
        } else {
            doneButton.isUserInteractionEnabled = false
            doneButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            signup(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, password: passwordTextField.text!)
        }
        return true
    }
    
    @IBAction func onDone(_ sender: Any) {
        signup(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, password: passwordTextField.text!)
    }
    
    func errorSignup() {
        let alert = UIAlertController(title: "Invalid Signup", message: "Email already in use. Please use another email.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabBarController
        destinationVC.currentUser = sender as? user
    }
    
    func signup(firstName: String, lastName: String, email: String, phone: String, password: String) {
        let url = URL(string: "http://127.0.0.1:8080/signup")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password,
            "mobile_number": phone
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:userResponse
            do {
                result = try JSONDecoder().decode(userResponse.self, from: data!)
                
                if (result.code == 600) {
                    DispatchQueue.main.async {
                        self.errorSignup()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueFinishSignUp", sender: result.data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

