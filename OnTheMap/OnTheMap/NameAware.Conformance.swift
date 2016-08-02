//
//  NameAware.Conformance.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/2/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

extension LoginViewController : NameAware  {
    var name: String {
        get { return String(LoginViewController.self) }
    }
}

extension MapViewController : NameAware  {
    var name: String {
        get { return String(MapViewController.self) }
    }
}

extension ListViewController : NameAware  {
    var name: String {
        get { return String(ListViewController.self) }
    }
}

extension PostViewController : NameAware {
    var name: String {
        get { return String(PostViewController.self) }
    }
}
