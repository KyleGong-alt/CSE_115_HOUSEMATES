//
//  FirstLastNameVC.swift
//  Housemates
//
//  Created by Jackson Tran on 4/19/22.
//

import UIKit

class FirstLastNameVC: UIViewController, UITextFieldDelegate {

    // OUTLETS
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        setBottomBorder(textfield: firstNameTextField)
        setBottomBorder(textfield: lastNameTextField)
    }
    
    // End text editing when tapping screen other than textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Disable signInButton if emailTextField or passwordTextField is empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (!(firstNameTextField.text?.count == 0) && !(lastNameTextField.text?.count == 0)) {
            nextButton.isUserInteractionEnabled = true
            nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 1)
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            onNext(self)
        }
        return true
    }
    
    
    @IBAction func onNext(_ sender: Any) {
        performSegue(withIdentifier: "segueToEmailPhone", sender: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
