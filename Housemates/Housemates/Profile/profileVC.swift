//
//  profileVC.swift
//  Housemates
//
//  Created by Luciano Villacrucis on 4/28/22.
//

import UIKit
import Foundation


class profileVC: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var logoutButton: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var password: UILabel!
    var user = users()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.bounds.width/2
        let url = "http://localhost:8080/list_users"
        getData(from: url)
        setProfilePic()
//        firstName.text = user.first_name
        // Do any additional setup after loading the view.
    }
    
    private func getData(from input: String){
        let url = URL(string: input)!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let dataTask =  URLSession.shared.dataTask(with: request) {data, response, error in
            var result:Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data!)
            }
            catch{
                print(error.localizedDescription)
            }
            guard let json =  result else{
                return
            }
            let locUser = json.data![0]
            DispatchQueue.main.async{
                self.firstName.text = locUser.first_name
                self.lastName.text = locUser.last_name
                self.email.text = locUser.email
                self.phoneNumber.text = locUser.mobile_number
                self.password.text = locUser.password
            }
        }
        dataTask.resume()
    }
    private func setFirstName(string input: String){
        self.firstName.text = "Hello"
    }
    private func setProfilePic(){
        let urlString = "http://localhost:8080/profilePic"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {

                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }

            DispatchQueue.main.async {
                self.profilePic.image = UIImage(data: data!)
            }
        }.resume()
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


struct Response: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [users]?
}

struct users: Codable{
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let password: String
    let mobile_number: String
    let house_code: String?
    init(){
        id = -1;
        email = ""
        first_name = ""
        last_name = ""
        password  = ""
        mobile_number = ""
        house_code = ""
    }
}
