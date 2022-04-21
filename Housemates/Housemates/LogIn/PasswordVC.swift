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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doneButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        
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
            doneButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 1)
        } else {
            doneButton.isUserInteractionEnabled = false
            doneButton.tintColor = UIColor.init(red:36/255, green: 122/255, blue: 255/255, alpha: 0.5)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            // blank
        }
        return true
    }
    
    @IBAction func onDone(_ sender: Any) {
        //blank
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
