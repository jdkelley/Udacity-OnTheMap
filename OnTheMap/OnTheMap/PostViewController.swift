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
    
    var lat: Double?
    var lon: Double?
    
    var geocoder = CLGeocoder()
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField! { didSet { locationTextField.delegate = self } }
    @IBOutlet weak var urlTextField: UITextField! { didSet { urlTextField.delegate = self } }

    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var buttonBar: UIView!
    
    @IBOutlet weak var mapView: MKMapView! { didSet { mapView.delegate = self } }
    
    // MARK: Actions
    
    @IBAction func cancelled(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if locationTextField != nil {
            findOnTheMap()
            return
        }
        if urlTextField != nil {
            submit()
        }
    }
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        
        cancelButton.layer.cornerRadius = 5.0
        findButton.layer.cornerRadius = 5.0
        findButton.setTitle(UIText.FindButton, forState: .Normal)
        
        
        urlTextField.hidden = true
        setTextFieldPlaceholders()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Add the navigation bar back to it is there when we get back to the tabbarviewcontroller.
        navigationController?.navigationBarHidden = false
    }

    // MARK: - Custom Methods
    
    private func findOnTheMap() {
        
        // Make sure that locationTextField exists.
        guard locationTextField != nil else {
            return
        }
        
        // Unwrap the text in locationTextField.
        guard let text = locationTextField.text else {
            return
        }
        
        location = text
        geocoder.geocodeAddressString(text) { (places, error) in
            guard error == nil else {
                UI.performUIUpdate{
                    self.alertUser(message: "Geocoder failed to parse the given location string.")
                }
                return
            }
            
            guard let placemarks = places where placemarks.count > 0 else {
                UI.performUIUpdate{
                    self.alertUser(message: "Geocoder failed to find location [0].")
                }
                return
            }
            
            UI.performUIUpdate{
                let place = placemarks[0]
                guard let coordinate = place.location?.coordinate else {
                    self.alertUser(message: "Geocoder failed to find location [1].")
                    return
                }
                self.lat = coordinate.latitude
                self.lon = coordinate.longitude
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                self.mapView.addAnnotation(annotation)
            }
        }
        changeInputStates()
    }
    
    private func submit() {
        
        // Make sure that urlTextField exists.
        guard urlTextField != nil else {
            return
        }
        
        // unwrap the text in urlTextField
        guard let text = urlTextField.text else {
            return
        }
        
        guard let lat = lat,
              let lon = lon
        else {
            UI.performUIUpdate{
                self.alertUser(message: "Geocoder failed to find location [2].")
            }
            return
        }
        
        ParseClient.sharedInstance.postNewLocation(mediaURL: text, mapString: location, lat: lat, long: lon) { (errorString) in
            UI.performUIUpdate{
                guard errorString == nil else {
                    self.alertUser(message: "Failed to post your pin.")
                    return
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: UI Methods
    
    private func changeInputStates() {
        findButton.setTitle(UIText.SubmitButton, forState: .Normal)
        
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
    
    private func alertUser(message message: String, title: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true) {
            NSLog((title ?? "") + message)
        }
    }
}

// MARK: - UI Text Field Delegate

extension PostViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if locationTextField != nil && textField == locationTextField {
            textField.resignFirstResponder()
            findOnTheMap()
            return true
        }
        if textField == urlTextField {
            textField.resignFirstResponder()
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: Images.mappin)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
}
