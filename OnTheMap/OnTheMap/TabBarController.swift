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
        // logout
        LoginManager().logOut()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func pinLocation() {
        print("Pin Pressed")
        if let postVC = storyboard?.instantiateViewControllerWithIdentifier(Identifiers.PostViewController) as? PostViewController {
            navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    func refreshData() {
        print("Refresh")
//        ParseClient.sharedInstance.studentLocations(

    }
    
    func displayYESNOAlert(message message: String, title: String, yes: () -> Void, no: () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            no()
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            yes()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true) {
            
        }
    }
}
