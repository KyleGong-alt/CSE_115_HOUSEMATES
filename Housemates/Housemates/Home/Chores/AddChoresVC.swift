//
//  AddChoresVC.swift
//  Housemates
//
//  Created by Jackson Tran on 5/6/22.
//

import UIKit

class AddChoresVC: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var dateTopView: UIView!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var dateBottomView: UIView!
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var assignTopView: UIView!
    
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        setBottomBorder(textfield: titleTextField)
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 13
        descriptionTextView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        descriptionTextView.text = "Add a Description"
        descriptionTextView.textColor = UIColor.lightGray
        
        dateTopView.layer.cornerRadius = 13
        dateTopView.layer.borderWidth = 1
        dateTopView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        dateBottomView.layer.cornerRadius = 13
        dateBottomView.layer.borderWidth = 1
        dateBottomView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        assignTopView.layer.cornerRadius = 13
        assignTopView.layer.borderWidth = 1
        assignTopView.layer.borderColor = UIColor.init(red:65/255, green: 125/255, blue: 122/255, alpha: 1).cgColor
        
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateButton.setTitle(dateFormatter.string(from: date), for: .normal)
        dateBottomView.isHidden = true
        datePicker.isHidden = true
        datePicker.minimumDate = date
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Add a Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func onDateTouch(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.dateBottomView.isHidden = !self.dateBottomView.isHidden
            self.datePicker.isHidden = !self.datePicker.isHidden
        }
    }
    @IBAction func onDateChange(_ sender: Any) {
        dateButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
    }
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onAssign(_ sender: Any) {
    }
}
