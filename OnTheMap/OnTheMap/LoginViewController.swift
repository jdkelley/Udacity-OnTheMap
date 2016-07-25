//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signUPButton: UIButton!

    @IBAction func loginWithFB(sender: UIButton) {
        //
    }
    
    @IBAction func loginWithPassword(sender: UIButton) {
        //
    }
    
    @IBAction func signUp(sender: UIButton) {
        if let url = NSURL(string: UdacityClient.SignUp) {
            url.openInSafari()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundGradient()
        setTextFieldPlaceholders()
        padMultipleTextFields(emailTextField, passwordTextField)
        
    }
    
    // MARK: UI Helpers
    
    private func setBackgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [Colors.UOrange.light.CGColor, Colors.UOrange.dark.CGColor]
        gradient.startPoint = CGPointMake(0.5,0.0)
        gradient.endPoint = CGPointMake(0.5, 1.0)
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func setTextFieldPlaceholders() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
    
    private func padMultipleTextFields(textfields: UITextField...) {
        for textfield in textfields {
            textfield.leftPad(by: 8)
        }
    }
}

extension LoginViewController : NameAware  {
    var name: String {
        get { return String(LoginViewController.self) }
    }
}

