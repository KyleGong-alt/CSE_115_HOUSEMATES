//
//  LoginVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/18/22.
//

import UIKit
import SwiftUI

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setBottomBorder(textfield: emailTextField)
        setBottomBorder(textfield: passwordTextField)

        // Do any additional setup after loading the view.
    }
    
    
    // End text editing when tapping screen other than textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Sets bottom border of the textfield
    func setBottomBorder(textfield: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
    }
    
    // Disable signInButton if emailTextField or passwordTextField is empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (!(emailTextField.text?.count == 0) && !(passwordTextField.text?.count == 0)) {
            signInButton.isUserInteractionEnabled = true
            signInButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 1)
        } else {
            signInButton.isUserInteractionEnabled = false
            signInButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            //sign in
        }
        return true
    }
}

