//
//  LoginVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/18/22.
//

import UIKit
import SwiftUI

class LoginVC: UIViewController, UITextFieldDelegate {

    // OUTLETS
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        
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
    
    // Disable signInButton if emailTextField or passwordTextField is empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (!(emailTextField.text?.count == 0) && !(passwordTextField.text?.count == 0)) {
            signInButton.isUserInteractionEnabled = true
            signInButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
        } else {
            signInButton.isUserInteractionEnabled = false
            signInButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
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
    
    @IBAction func onSignIn(_ sender: Any) {
        //segue to home
        performSegue(withIdentifier: "SignInSegue", sender: nil)
        return
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        performSegue(withIdentifier: "segueToSignUp", sender: nil)
    }
}

