//
//  EmailPhoneVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/19/22.
//

import UIKit

class EmailPhoneVC: UIViewController, UITextFieldDelegate {

    // OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var firstName: String!
    var lastName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up delegates and UI design
        nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        setBottomBorder(textfield: emailTextField)
        setBottomBorder(textfield: phoneTextField)
    }
    
    // End text editing when tapping screen other than textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Disable signInButton if emailTextField or passwordTextField is empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (!(emailTextField.text?.count == 0) && !(phoneTextField.text?.count == 0)) {
            nextButton.isUserInteractionEnabled = true
            nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        }
    }
    
    // Deals with textfield responders when user presses enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            textField.resignFirstResponder()
            onNext(self)
        }
        return true
    }
    
    // Limit character length in textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 32
    }

    // User press next
    @IBAction func onNext(_ sender: Any) {
        if !checkValidField() {
            return
        }
        performSegue(withIdentifier: "segueToPassword", sender: nil)
    }
    
    // Checks valid input for email and phone
    func checkValidField() -> Bool{
        if !isValidEmail(emailTextField.text!) {
            let alert = UIAlertController(title: "Invalid Email Input", message: "The email address you inputted is invalid. Please try again.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            return false
        }
        if !isValidPhone(phoneTextField.text!) {
            let alert = UIAlertController(title: "Invalid Phone Input", message: "The phone number you inputted is invalid. Please try again.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    // Preparation for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PasswordVC
        
        destinationVC.firstName = firstName
        destinationVC.lastName = lastName
        destinationVC.email = emailTextField.text
        destinationVC.phoneNumber = phoneTextField.text
    }
}
