//
//  UITextField.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/25/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

extension UITextField {
    func leftPad(by by: CGFloat) {
        self.leftViewMode = .Always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: by, height: self.bounds.height))
    }
    
    static func padMultipleTextFields(textfields: UITextField...) {
        for textfield in textfields {
            textfield.leftPad(by: 8)
        }
    }
}
