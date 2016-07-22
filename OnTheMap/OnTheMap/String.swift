//
//  String.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension String {
    func substitute(key key: String, forValue: String) -> String? {
        if self.containsString("{\(key)}") {
            return self.stringByReplacingOccurrencesOfString("{\(key)}", withString: forValue)
        } else {
            return nil
        }
    }
}
