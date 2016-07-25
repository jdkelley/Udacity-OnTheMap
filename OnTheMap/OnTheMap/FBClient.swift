//
//  FBClient.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

class FBClient {
    
    var sessionID: String?
    
    // MARK: Singleton
    
    static let sharedInstance = FBClient()
    private init() {}
}
