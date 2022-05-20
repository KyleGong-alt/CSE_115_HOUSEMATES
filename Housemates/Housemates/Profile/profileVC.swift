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
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    var currentUser: user?
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.bounds.width/2
        profilePic.layer.borderWidth = 1
        profilePic.layer.borderColor = UIColor.white.cgColor
        
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = .zero
        topView.layer.shadowRadius = 10
        
        setBorder(view: firstNameView, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(view: lastNameView, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(view: emailView, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(view: phoneNumberView, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(view: passwordView, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(view: passwordView, height: passwordView.frame.height, color: UIColor.opaqueSeparator.cgColor)
        
        setBorder(button: signOutButton, height: 0, color: UIColor.opaqueSeparator.cgColor)
        setBorder(button: signOutButton, height: signOutButton.frame.height, color: UIColor.opaqueSeparator.cgColor)
        
        signOutButton.layer.shadowColor = UIColor.black.cgColor
        signOutButton.layer.shadowOpacity = 0.2
        signOutButton.layer.shadowOffset = .zero
        signOutButton.layer.shadowRadius = 10
        
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.2
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowRadius = 10
        
        firstNameTextField.text = currentUser?.first_name
        lastNameTextField.text = currentUser?.last_name
        emailTextField.text = currentUser?.email
        phoneNumberTextField.text = currentUser?.mobile_number
        touche
//        setProfilePic()
//        firstName.text = user.first_name
        // Do any additional setup after loading the view.
    }
    
    func updatePhone(phone: String) {
        phoneNumberTextField.text = format(with: "(XXX) XXX-XXX", phone: phone)
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "email")
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = main.instantiateViewController(withIdentifier: "LoginVC")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginVC
        let transition = CATransition()

        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.default)
        
        delegate.window?.layer.add(transition, forKey: kCATransition)
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
}
