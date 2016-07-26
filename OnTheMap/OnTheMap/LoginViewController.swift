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
    @IBOutlet weak var emailTextField: UITextField! { didSet { emailTextField.delegate = self }}
    @IBOutlet weak var passwordTextField: UITextField! {didSet { passwordTextField.delegate = self }}
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signUPButton: UIButton!

    @IBAction func loginWithFB(sender: UIButton) {
        //
    }
    
    @IBAction func loginWithPassword(sender: UIButton) {
        guard   let email = emailTextField.text,
                let pw = passwordTextField.text else {
                // pulse and warn user
                return
        }
        UdacityClient.sharedInstance.loginWithPassword((email, pw)) { (success, errorString) in
            if success {
                UI.performUIUpdate {
                    // TODO: Clear TextFields and transition
                    UdacityClient.sharedInstance.account.loggedin = true // completion handler
                }
            }
        }
    }
    
    @IBAction func signUp(sender: UIButton) {
        if let url = NSURL(string: UdacityClient.SignUp) {
            url.openInSafari()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundGradient()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setTextFieldPlaceholders()
        padMultipleTextFields(emailTextField, passwordTextField)
    }
    
    // MARK: Login Flow
    
    func login() {
        
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordTextField && (emailTextField.text ?? "").characters.count > 0 {
            login()
        }
        return true
    }
}

extension LoginViewController : NameAware  {
    var name: String {
        get { return String(LoginViewController.self) }
    }
}

