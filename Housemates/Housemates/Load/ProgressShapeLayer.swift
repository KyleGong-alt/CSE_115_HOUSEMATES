//
//  ProgressShapeLayer.swift
//  Housemates
//
//  Created by Jackson Tran on 5/27/22.
//

import UIKit

class ProgressShapeLayer: CAShapeLayer {
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code:) is not implemented")
    }
}
