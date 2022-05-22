//
//  ProfilePicVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/20/22.
//

import UIKit

class ProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var type: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if type == 0 && UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
