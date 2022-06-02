//
//  AddHouseVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/17/22.
//

import UIKit

class AddHouseVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var houseCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        houseCodeTextField.delegate = self
        houseCodeTextField.layer.cornerRadius = 13
        
    }
    
    // Dismiss view
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // User press join
    @IBAction func onJoinHouse(_ sender: Any) {
        join_house()
    }
    
    // User press create house
    @IBAction func onCreateHouse(_ sender: Any) {
        create_house()
    }
    
    // Deals with invalid house code when joining house
    func errorAddHouse() {
        let alert = UIAlertController(title: "The house code you entered does not exist", message: "The house code you entered does not exist. Please try again.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    // Preparation for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAddedHouse" {
            if currentUser!.house_code != nil{
            } else {
                let updatedUser = user(id: currentUser!.id, first_name: currentUser!.first_name, last_name: currentUser!.last_name, house_code: houseCodeTextField.text, mobile_number: currentUser!.mobile_number, email: currentUser!.email, password: currentUser!.password)
                currentUser = updatedUser
            }
        }
    }
    
    // Join house request
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
                print("server not connected!")
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
    
    // Create house request
    func create_house() {
        let url = URL(string: "http://127.0.0.1:8080/create_house")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        guard let _ = currentUser?.id else {return}
        
        let parameters: [String: Any] = [
            "user_id": String(currentUser!.id),
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: postResponse
            guard let data = data else {
                print("server not connected")
                return
            }
            do {
                result = try JSONDecoder().decode(postResponse.self, from: data)
                if (result.code != 200) {
                    return
                }

                DispatchQueue.main.async {
                    self.get_user()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    // Get user request
    func get_user() {
        var components = URLComponents(string: "http://127.0.0.1:8080/get_user")!
        components.queryItems = [
            URLQueryItem(name: "email", value: currentUser?.email)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:userResponse
            do {
                guard let data = data else {
                    print("server not connected")
                    return
                }
                result = try JSONDecoder().decode(userResponse.self, from: data)
                if (result.data == nil) {
                    return
                }
                currentUser = result.data
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
