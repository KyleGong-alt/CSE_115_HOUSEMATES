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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        
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
            nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 1)
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            textField.resignFirstResponder()
            onNext(self)
        }
        return true
    }

    @IBAction func onNext(_ sender: Any) {
        //segue to password
        performSegue(withIdentifier: "segueToPassword", sender: nil)
    }
}
