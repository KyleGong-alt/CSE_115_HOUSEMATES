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
        nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
        
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
            nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1)
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.tintColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 0.5)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 32
    }
    
    @IBAction func onNext(_ sender: Any) {
        performSegue(withIdentifier: "segueToEmailPhone", sender: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EmailPhoneVC
        destinationVC.firstName = firstNameTextField.text
        destinationVC.lastName = lastNameTextField.text
    }
    

}
