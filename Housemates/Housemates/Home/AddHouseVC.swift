//
//  AddHouseVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/17/22.
//

import UIKit

class AddHouseVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var houseCodeTextField: UITextField!
    
    var currentUser: user?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        houseCodeTextField.delegate = self
        houseCodeTextField.layer.cornerRadius = 13
        
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onJoinHouse(_ sender: Any) {
        join_house()
    }
    
    func errorAddHouse() {
        let alert = UIAlertController(title: "The house code you entered does not exist", message: "The house code you entered does not exist. Please try again.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAddedHouse" {
            let updatedUser = user(id: self.currentUser!.id, first_name: self.currentUser!.first_name, last_name: self.currentUser!.last_name, house_code: self.houseCodeTextField.text, mobile_number: self.currentUser!.mobile_number, email: self.currentUser!.email, password: self.currentUser!.password)
            let destinationVC = segue.destination as! TabBarController
            destinationVC.currentUser = updatedUser
        }
    }
    
    func join_house() {
        let url = URL(string: "http://127.0.0.1:8080/join_house")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        guard let _ = currentUser?.id, let _ = houseCodeTextField.text else {return}
        
        let parameters: [String: Any] = [
            "user_id": String(currentUser!.id),
            "house_code": houseCodeTextField.text!
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: postResponse
            guard let data = data else {
                print("OUT")
                return
            }
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data)
                if (result.code != 200) {
                    DispatchQueue.main.async {
                        self.errorAddHouse()
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueAddedHouse", sender: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
