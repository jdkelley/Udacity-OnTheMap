//
//  NSURL.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/25/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

extension NSURL {
    func openInSafari() {
        UIApplication.sharedApplication().openURL(self)
    }
}
