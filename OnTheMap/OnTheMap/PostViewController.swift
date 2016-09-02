//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/2/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
    
    // MARK: - Properties
    var location = ""
    var url = ""

    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!

    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var buttonBar: UIView!
    
    @IBOutlet weak var enterLocation: UITextField! { didSet { enterLocation.delegate = self } }
    
    @IBOutlet weak var mapView: MKMapView! { didSet { mapView.delegate = self } }
    
    // MARK: Actions
    
    @IBAction func cancelled(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if locationTextField != nil {
            findOnTheMap() 
        }
    }
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.cornerRadius = 5.0
        findButton.layer.cornerRadius = 5.0
        
        
        urlTextField.hidden = true
        setTextFieldPlaceholders()
        
    }

    // MARK: - Custom Methods
    
    private func findOnTheMap() {
        guard locationTextField != nil else {
            return
        }
        
        guard let text = locationTextField.text else {
            return
        }
        
        location = text
        changeInputStates()
    }
    
    private func submit() {
        guard urlTextField != nil else {
            return
        }
        
        guard let text = urlTextField.text else {
            return
        }
        
        url = text
        
        
        guard postPin() else {
            // raise error box
            return
        }
        
        urlTextField.removeFromSuperview()
        
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func postPin() -> Bool {
        // post to Parse
        
        return false
    }
    
    // MARK: UI Methods
    
    private func changeInputStates() {
        findButton.setTitle("Submit", forState: .Normal)
        //let pointA = self.midView.frame.origin.y
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.buttonBar.backgroundColor = Colors.barGray
            self.midView.transform = CGAffineTransformMakeTranslation(0, -self.midView.frame.height)
            self.bottomLabel.alpha = 0.0
            self.midLabel.alpha = 0.0
            self.topLabel.alpha = 0.0
            self.urlTextField.hidden = false
            self.cancelButton.setTitleColor(.whiteColor(), forState: .Normal)
        }) { (success) in
            
            // Remove Location TextField
            self.locationTextField.removeFromSuperview()
            
            self.topBar.backgroundColor = Colors.postPinBlue
            
            // Remove MidView after finish translating
            self.midView.removeFromSuperview()
            
            // Remove "where are you studying" labels
            self.bottomLabel.removeFromSuperview()
            self.midLabel.removeFromSuperview()
            self.topLabel.removeFromSuperview()
        }
    }
    
    private func setTextFieldPlaceholders() {
        urlTextField.attributedPlaceholder = NSAttributedString(string: UIText.EnterLinkPlaceholder, attributes: [ NSForegroundColorAttributeName: Colors.placeholderWhite ])
        locationTextField.attributedPlaceholder = NSAttributedString(string: UIText.EnterLocationPlaceholder, attributes: [ NSForegroundColorAttributeName: Colors.placeholderWhite ])
    }
}

// MARK: - UI Text Field Delegate

extension PostViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == locationTextField {
            findOnTheMap()
            return true
        }
        if textField == urlTextField {
            submit()
            return true
        }
        return true
    }
    
    // When you touch off the keyboard, dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - MK Map View Delegate

extension PostViewController : MKMapViewDelegate {
    
    
}
