//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/1/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController {
    
    // MARK: - Properties
    
    var data = StudentDataSource.sharedInstance.annotations {
        didSet {
            removeAllAnnotations()
            addAnnotations()
        }
    }

    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.hidden = false
        mapView.delegate = self
        addAnnotations()
    }
    
    // MARK: - Custom Methods
    
    func addAnnotations() {
        self.mapView.addAnnotations(StudentDataSource.sharedInstance.annotations)
    }
    
    private func removeAllAnnotations() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
}

extension MapViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: Images.mappin)
            pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard   let urlString = view.annotation?.subtitle,
                    let string = urlString,
                    let url = NSURL(string: string) else {
                        print("url?: \(view.annotation)")
                return
            }
            url.openInSafari()
        }
    }
}
