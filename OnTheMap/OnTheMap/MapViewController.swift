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
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    // MARK: - Custom Methods
    
}

extension MapViewController : MKMapViewDelegate {
    
}

extension MapViewController : NameAware  {
    var name: String {
        get { return String(MapViewController.self) }
    }
}
