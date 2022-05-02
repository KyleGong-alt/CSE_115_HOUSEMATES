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

func segue(srcVC: UIViewController, destVC: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.25
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    
    //srcVC.navigationController.view.add
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
