//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/7/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import FacebookLogin

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UIText.Logout, style: .Plain, target: self, action: #selector(logout))
        navigationItem.title = UIText.OnTheMap
        let pin = UIBarButtonItem(image: UIImage(named: Images.pin), style: .Plain, target: self, action: #selector(pinLocation))
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItems = [refresh, pin]
    }
    
    func logout() {
        print("Pressed Logout")
        
        if UdacityClient.sharedInstance.account.isFacebookSession {
            LoginManager().logOut()
        }
        
        UdacityClient.sharedInstance.deleteSessionInfo {
            UI.performUIUpdate {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func pinLocation() {
        print("Pin Pressed")
        if let postVC = storyboard?.instantiateViewControllerWithIdentifier(Identifiers.PostViewController) as? PostViewController {
            presentViewController(postVC, animated: true, completion: nil)
            //navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    func refreshData() {
        print("Refresh")
        ParseClient.sharedInstance.studentLocations({ (success, errorString) in
            guard success else {
                self.alertUser(message: UIText.DataError, title: nil)
                NSLog(errorString ?? "")
                return
            }
            print("Action Completed")
        })
    }
    
    func alertUser(message message: String, title: String?) {
        UI.performUIUpdate {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            
            alertController.addAction(dismissAction)
            
            self.presentViewController(alertController, animated: true) {
                NSLog(UIText.DataError)
            }
        }
    }
}
