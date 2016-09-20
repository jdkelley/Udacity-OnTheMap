//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {
    
    var fbbutton: LoginButton!
    
    @IBOutlet weak var emailTextField: UITextField! { didSet { emailTextField.delegate = self }}
    @IBOutlet weak var passwordTextField: UITextField! { didSet { passwordTextField.delegate = self }}
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButtonView: UIView!
    @IBOutlet weak var signUPButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    @IBAction func loginWithPassword(sender: UIButton) {
        NSLog("pressed")
        guard   let email = emailTextField.text where email != "",
                let pw = passwordTextField.text where pw != ""
        else {
            let alertController = UIAlertController(title: nil, message: "Must enter both a username and password.", preferredStyle: .Alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                print("okay pressed")
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true) {}
            
            return // no password.
        }
        UI.performUIUpdate { 
            self.spinner.startAnimating()
            self.enableUI(to: false)
        }
        UdacityClient.sharedInstance.loginWithPassword((email, pw)) { (success, errorString) in
            
            if success {
                NSLog("Made it!! SessionID: \(UdacityClient.sharedInstance.sessionID)")
                NSLog("Unique Key: \(UdacityClient.sharedInstance.account.accountID)")
                NSLog("First Name: \(UdacityClient.sharedInstance.account.firstName)")
                NSLog("Last Name: \(UdacityClient.sharedInstance.account.lastName)")
                
                guard let _ = UdacityClient.sharedInstance.account.accountID else {
                    NSLog("AccountID Not Found!")
                    return
                }
                
                UI.performUIUpdate {
                    self.spinner.stopAnimating()
                    self.enableUI(to: true)
                    self.pushTabBar()
                    UdacityClient.sharedInstance.account.loggedin = true // completion handler
                }
            } else {
                UdacityClient.sharedInstance.account.loggedin = false
                UI.performUIUpdate {
                    //let message = ((errorString ?? "") == UdacityClient.LoginMessages.InvalidEmail) ? UdacityClient.LoginMessages.InvalidEmail : "Failed to connect. Please verify your connection to the internet."
                    
                    let message: String
                    
                    if (errorString ?? "") == UdacityClient.LoginMessages.InvalidEmail {
                        message = UdacityClient.LoginMessages.InvalidEmail
                    } else if (errorString ?? "") == UdacityClient.LoginMessages.ErrorDownloadingUserInfo {
                        message = UdacityClient.LoginMessages.ErrorDownloadingUserInfo
                    } else if (errorString ?? "") == UdacityClient.LoginMessages.NoLocationsFound {
                        message = UdacityClient.LoginMessages.NoLocationsFound
                    } else {
                        message = "Oops! Something went wrong when we tried to log you in."
                    }
                    
                    
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        print("okay pressed")
                    }
                    alertController.addAction(okayAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        self.spinner.stopAnimating()
                        self.enableUI(to: true)
                    }
                    
                }
                NSLog("not successful? - \(errorString ?? "")")
            }
        }
    }

    func enableUI(to to: Bool) {
        loginButton.enabled = to
        emailTextField.enabled = to
        passwordTextField.enabled = to
        fbButtonView.userInteractionEnabled = to
    }
    
    @IBAction func signUp(sender: UIButton) {
        if let url = NSURL(string: UdacityClient.SignUp) {
            url.openInSafari()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundGradient()
        
        fbbutton = LoginButton(readPermissions: [.PublicProfile, .Email])
        fbbutton.delegate = self //FBClient.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UI.performUIUpdate { 
            self.navigationController?.navigationBarHidden = true
            
            self.spinner.hidesWhenStopped = true
            self.spinner.stopAnimating()
            self.setTextFieldPlaceholders()
            UITextField.padMultipleTextFields(self.emailTextField, self.passwordTextField)
            
            self.fbButtonView.addSubview(self.fbbutton)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fbbutton.frame = fbButtonView.bounds
    }
    
    // MARK: UI Helpers
    
    private func setBackgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [Colors.UOrange.light.CGColor, Colors.UOrange.dark.CGColor]
        gradient.startPoint = CGPointMake(0.5, 0.0)
        gradient.endPoint = CGPointMake(0.5, 1.0)
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func setTextFieldPlaceholders() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordTextField && (emailTextField.text ?? "").characters.count > 0 {
            loginWithPassword(UIButton())
        }
        return true
    }
    
    // When you touch off the keyboard, dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidCompleteLogin(loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .Cancelled:
            NSLog("Login Button - Cancelled")
            return
        case .Failed(let error):
            NSLog("Login Button - Failed: \(error)")
                        return
        case .Success(let granted, let declined, let token):
            NSLog("Login Button - Succeeded: \(token.authenticationToken)")
            UdacityClient.sharedInstance.loginWithFB(token.authenticationToken) { (success, errorString) in
                if success {
                    NSLog("Made it!! SessionID: \(UdacityClient.sharedInstance.sessionID)")
                    NSLog("Unique Key: \(UdacityClient.sharedInstance.account.accountID)")
                    NSLog("First Name: \(UdacityClient.sharedInstance.account.firstName)")
                    NSLog("Last Name: \(UdacityClient.sharedInstance.account.lastName)")
                    
                    guard let _ = UdacityClient.sharedInstance.account.accountID else {
                        NSLog("AccountID Not Found!")
                        return
                    }
                    
                    UI.performUIUpdate {
                        self.spinner.stopAnimating()
                        self.enableUI(to: true)
                        self.pushTabBar()
                        UdacityClient.sharedInstance.account.loggedin = true // completion handler
                        UdacityClient.sharedInstance.account.isFacebookSession = true
                    }
                } else {
                    UI.performUIUpdate {
                        self.spinner.stopAnimating()
                        self.enableUI(to: true)
                        // TODO: Clear TextFields and transition
                        UdacityClient.sharedInstance.account.loggedin = false // completion handler
                        UdacityClient.sharedInstance.account.isFacebookSession = false
                    }
                    NSLog("not successful? - \(errorString ?? "")")
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: LoginButton) {
        NSLog("Logged out of facebook successfully!")
//        UdacityClient.sharedInstance.logout()
        NSLog("Facebook SDK Reports It has Logged out.")
    }
    
    func pushTabBar() {
        if let tbvc = storyboard?.instantiateViewControllerWithIdentifier(Identifiers.TabBarController) as? TabBarController {
            navigationController?.pushViewController(tbvc, animated: true)
        }
    }
    
}
