//
//  AddRuleVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/24/22.
//

import UIKit

class AddRuleVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!

    var parentVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegates and UI design
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        setBottomBorder(textfield: titleTextField)
        
        descriptionTextField.delegate = self
        descriptionTextField.layer.cornerRadius = 13
        descriptionTextField.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        descriptionTextField.text = "Add a Description"
        descriptionTextField.textColor = UIColor.lightGray
        
        
    }
    
    // End text editing when tapping screen other than textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UI responding to when descriptionTextField is being edit
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // UI responding to when descriptionTextField is done editting
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextField.text.isEmpty {
            descriptionTextField.text = "Add a Description"
            descriptionTextField.textColor = UIColor.lightGray
        }
    }
    
    // Limit character length in textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        switch textField {
        case titleTextField:
            return count <= 45
        default:
            return count <= 64
        }
    }
    
    // Limit character length in textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldText = textView.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        switch textView {
        case descriptionTextField:
            return count <= 200
        default:
            return count <= 100
        }
    }
    
    // User press add
    @IBAction func onAdd(_ sender: Any) {
        if titleTextField.text!.isEmpty || descriptionTextField.text!.isEmpty {
            errorAddRule()
        }
        createHouseRules(house_code: currentUser!.house_code! , title: titleTextField.text!, description: descriptionTextField.text!, voted_num: 0)
        
    }
    
    // Deals with error adding rules
    func errorAddRule() {
        let alert = UIAlertController(title: "Empty Text Field", message: "One or more textfield is empty. Please fill in those textfields.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    // Dismiss view
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Create house rule request
    func createHouseRules(house_code: String, title: String, description: String, voted_num: Int) {
        let url = URL(string: "http://127.0.0.1:8080/create_house_rules")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "house_code": house_code,
            "title": title,
            "description": description,
            "voted_num": String(voted_num),
            "valid": 0
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:postResponse
            do {
                guard let data = data else {
                    print("Server not connected!")
                    return
                }
                
                result = try JSONDecoder().decode(postResponse.self, from: data)
                if result.code != 200 {
                    print(result)
                    return
                }
                DispatchQueue.main.async {
                    if let parentVC = self.parentVC as? HomeVC{
                        parentVC.loaded = 2
                        parentVC.getUserUnvotedRules()
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
