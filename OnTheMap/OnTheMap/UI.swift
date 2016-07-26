//
//  UI.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/26/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

struct UI {
    static func performUIUpdate(update: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            update()
        }
    }
}
