//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField! { didSet { emailTextField.delegate = self }}
    @IBOutlet weak var passwordTextField: UITextField! {didSet { passwordTextField.delegate = self }}
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signUPButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func loginWithFB(sender: UIButton) {
        // call FB SDK
        // on return use token with
//        UdacityClient.sharedInstance.loginWithFB(token) { (success, errorString) in
//            if success {
//                UI.performUIUpdate {
//                    // TODO: Clear TextFields and transition
//                    UdacityClient.sharedInstance.account.loggedin = true // completion handler
//                }
//            }
//        }
    }
    
    @IBAction func loginWithPassword(sender: UIButton) {
        print("presed")
        guard   let email = emailTextField.text,
                let pw = passwordTextField.text else {
                // pulse and warn user
                    print("no password")
                return
        }
        spinner.startAnimating()
        enableUI(to: false)
        UdacityClient.sharedInstance.loginWithPassword((email, pw)) { (success, errorString) in
            
            if success {
                print("Made it!!! SessionID: \(UdacityClient.sharedInstance.sessionID)")
                print("Unique Key: \(UdacityClient.sharedInstance.account.accountID)")
                print("First Name: \(UdacityClient.sharedInstance.account.firstName)")
                print("LastName:: \(UdacityClient.sharedInstance.account.lastName)")
                
                guard let id = UdacityClient.sharedInstance.account.accountID else {
                    print("AccountID Not Found")
                    return
                }
                
                ParseClient.sharedInstance.previousLocation(uniqueKey: id, completionHandlerForPreviousLocation: { (exists, errorString) in
                    if exists {
                        print("Exists")
                        UdacityClient.sharedInstance.account.hasPreviousUpload = true
                    } else {
                        print("Does not exist")
                        UdacityClient.sharedInstance.account.hasPreviousUpload = false
                    }
                })
                
                UI.performUIUpdate {
                    self.spinner.stopAnimating()
                    self.enableUI(to: true)
                    // TODO: Clear TextFields and transition
                    UdacityClient.sharedInstance.account.loggedin = true // completion handler
                }
            } else {
                UI.performUIUpdate {
                    self.spinner.stopAnimating()
                    self.enableUI(to: true)
                    // TODO: Clear TextFields and transition
                    UdacityClient.sharedInstance.account.loggedin = false // completion handler
                }
                print("not successful? - \(errorString ?? "")")
            }
        }
    }
    
    func enableUI(to to: Bool) {
        loginButton.enabled = to
        emailTextField.enabled = to
        passwordTextField.enabled = to
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
        self.tabBarController?.tabBar.hidden = true
        
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
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
    
    // When you touch off the keyboard, dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController : NameAware  {
    var name: String {
        get { return String(LoginViewController.self) }
    }
}

