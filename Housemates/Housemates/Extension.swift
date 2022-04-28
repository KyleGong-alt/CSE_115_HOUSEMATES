//
//  Extension.swift
//  Housemates
//
//  Created by Jackson Tran on 4/19/22.
//

import Foundation
import UIKit

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
