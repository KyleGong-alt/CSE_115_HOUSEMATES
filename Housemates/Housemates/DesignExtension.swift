//
//  Extension.swift
//  Housemates
//
//  Created by Jackson Tran on 4/19/22.
//

import Foundation
import UIKit
import QuartzCore

// Sets bottom border of the textfield
func setBottomBorder(textfield: UITextField) {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.lightGray.cgColor
    textfield.borderStyle = UITextField.BorderStyle.none
    textfield.layer.addSublayer(bottomLine)
}

func setBottomBorder(label: UILabel, height: CGFloat, color: CGColor) {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: label.frame.height + height, width: label.frame.width, height: 1.0)
    bottomLine.backgroundColor = color
    label.layer.addSublayer(bottomLine)
}

func setBorder(view: UIView, height: CGFloat, color:CGColor) {
    let line = CALayer()
    line.frame = CGRect(x: 0.0, y: height, width: view.frame.width, height: 1.0)
    line.backgroundColor = color
    view.layer.addSublayer(line)
}

func setBorder(button: UIButton, height: CGFloat, color:CGColor) {
    let line = CALayer()
    line.frame = CGRect(x: 0.0, y: height, width: button.frame.width, height: 1.0)
    line.backgroundColor = color
    button.layer.addSublayer(line)
}


func segue(srcVC: UIViewController, destVC: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.25
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    
    //srcVC.navigationController.view.add
}

/// mask example: `+X (XXX) XXX-XXXX`
func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])

            // move numbers iterator to the next index
            index = numbers.index(after: index)

        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}


extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

