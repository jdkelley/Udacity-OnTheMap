//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/2/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var buttonBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.cornerRadius = 5.0
    }
    
    
    
    
    
    
}
