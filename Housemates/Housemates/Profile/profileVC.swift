//
//  profileVC.swift
//  Housemates
//
//  Created by Luciano Villacrucis on 4/28/22.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

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
    
    var containerView = UIView()
    var slideUpView = UITableView()
    let screenSize = UIScreen.main.bounds.size
    
    let slideUpViewDataSource: [Int: (UIImage?, String)] = [
        0: (UIImage(named: "camera"), "Take photo"),
        1: (UIImage(named: "photo.on.rectangle"), "Choose from library")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UI setup
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
        phoneNumberTextField.text = format(with: "(XXX) XXX-XXXX", phone: currentUser!.mobile_number)
        
        
        // Set up slide up view for profile picture
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        // dim container view when slide view pops up
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.frame = self.view.frame
        delegate.window?.addSubview(containerView)
        
        // tap gesture for the container view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.alpha = 0
        
        // Setup Slide up view
        slideUpView.frame = CGRect(x: 16, y: screenSize.height, width: screenSize.width - 32, height: 100)
        slideUpView.separatorStyle = .none
        slideUpView.layer.cornerRadius = 20
        delegate.window?.addSubview(slideUpView)
        slideUpView.isScrollEnabled = false
        slideUpView.delegate = self
        slideUpView.dataSource = self
        slideUpView.register(SlideUpViewCell.self, forCellReuseIdentifier: "SlideUpViewCell")
        setProfilePic(currentUser!.email, imageView: self.profilePic)
    }
    
    // Format phone number from XXXXXXXXXX to (XXX) XXX-XXXX
    func updatePhone(phone: String) {
        phoneNumberTextField.text = format(with: "(XXX) XXX-XXXX", phone: phone)
    }
    
    // Sign Out logic, segues back to loginVC
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
    
    // Begin touch recognizer on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // UI indicate user touched profile pic
        if touches.first?.view == self.profilePic {
            profilePic.layer.borderWidth = 4
        }
    }
    
    // End touch recognizer on screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // UI indicate user end touch profile pic
        if touches.first?.view == self.profilePic {
            profilePic.layer.borderWidth = 1
        }
    }
    
    // Long Hold Recognizer for profile pic. Slide up View appears
    @IBAction func onPicLongHold(_ sender: Any) {
        profilePic.layer.borderWidth = 1
        if (containerView.alpha != 0) {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.containerView.alpha = 0.8
            self.slideUpView.frame = CGRect(x: 16, y: self.screenSize.height - 116, width: self.screenSize.width - 32, height: 100)
        }, completion: nil)
        
    }
    
    // Dismiss slide up view
    @objc func slideUpViewTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.containerView.alpha = 0
            self.slideUpView.frame = CGRect(x: 16, y: self.screenSize.height, width: self.screenSize.width - 32, height: 100)
        }, completion: nil)
        
    }
    
    // Perform segue to EditProfileVC with sender to indicate which data is being edit
    @IBAction func onEditFirstName(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: "first_name")
    }
    
    @IBAction func onEditLastName(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: "last_name")
    }
    
    @IBAction func onEditEmail(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: "email")
    }
    
    @IBAction func onEditPhoneNumber(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: "phone")
    }
    
    @IBAction func onEditPassword(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: "password")
    }
    
    // Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditProfileVC
        destinationVC.sheetPresentationController?.detents = [.medium()]
        if let sender = sender as? String {
            destinationVC.editType = sender
            destinationVC.parentVC = self
        }
    }
    
}


extension profileVC: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Number of row for slide up view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        slideUpViewDataSource.count
    }
    
    // Loads each row base on data in slide up view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlideUpViewCell", for: indexPath) as? SlideUpViewCell
        else {fatalError("unable to deque SlideUpViewCell")}

        cell.iconView.image = slideUpViewDataSource[indexPath.row]?.0
        cell.labelView.text = slideUpViewDataSource[indexPath.row]?.1
        return cell
    }
    
    // Fixed height for row of slide up view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    // On selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slideUpViewTapped()
        //Set up image picker
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        // Camera or Photo Library
        if indexPath.row == 0 && UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
        
    // On finish with picking image, upload the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePic.image = image
        if let image = image {
            imageUpload(image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Upload image to server
    func imageUpload(_ image: UIImage) {
        let url = URL(string: "http://localhost:8080/profilePic?email="+currentUser!.email)!
        let imageData = image.jpegData(compressionQuality: 0.9)
        
        AF.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(imageData!, withName: "file", fileName: "profilePic", mimeType: "image/jpg")
        },to: url).response { response in
            print(response)
        }
    }
}
