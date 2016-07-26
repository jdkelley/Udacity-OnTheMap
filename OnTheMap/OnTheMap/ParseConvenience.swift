//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: TODO
    
    func previousLocation(uniqueKey uniqueKey: String) -> StudentLocation? {
        
        // Get Student Location for current User
        
        // If exists, return it
        // else return nil
        return nil
    }
    
    func postNewLocation() {
        
    }
    
    func updateExistingLocation() {
        
    }
    
    func locationsFrom(data data: AnyObject, completionHandlerForConvert: (result: [StudentLocation]?, error: NSError?) -> Void) {
        
        guard   let dictionary = data as? [String : AnyObject],
            let results = dictionary[JSONKeys.results] as? [[String : AnyObject]],
            let students = StudentLocation.studentLocations(results)
            else {
                completionHandlerForConvert(result: nil, error: NSError(domain: "locationListFrom parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not parse StudentLocation from data"]))
                return
        }
        completionHandlerForConvert(result: students, error: nil)
    }
}
