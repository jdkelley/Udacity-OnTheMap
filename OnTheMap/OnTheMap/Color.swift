//
//  UIColor.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/25/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

// Colors defined for On The Map.
extension UIColor {
    
    /// Various Udacity Oranges.
    struct UOrange {
        static let light = UIColor(red: 253.0 / 255.0, green: 134.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
        static let normal = UIColor(red: 253.0 / 255.0, green: 126.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
        static let dark = UIColor(red: 253.0 / 255.0, green: 88.0 / 255.0, blue: 6.0 / 255.0, alpha: 1.0)
    }
    
    /// The Color of the Login Button on the LoginViewController.
    static let buttonRed = UIColor(red: 238.0 / 255.0, green: 62.0 / 255.0, blue: 5.0 / 255.0, alpha: 1.0)
    
    /// The blue on the add pin screen.
    static let postPinBlue = UIColor(red: 63.0 / 255.0, green: 116.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
    
    /// The color of the gray top bar on the add pin screen.
    static let barGray = UIColor(red: 217.0 / 255.0, green: 217.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.4)
    
    /// Placeholder text color for textfields on the add pin screen.
    static let placeholderWhite = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
}
