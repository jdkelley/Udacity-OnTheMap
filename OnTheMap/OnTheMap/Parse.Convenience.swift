//
//  Parse.Convenience.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: TODO
    
    func previousLocation(uniqueKey uniqueKey: String, completionHandlerForPreviousLocation: (exists: Bool, errorString: String?) -> Void ) {
        let parameters: [String: AnyObject] = [
            ParameterKeys.Where: ParameterKeys.whereClause(uniqueKey)
        ]
        taskForGET(Methods.StudentLocation, parameters: parameters) { (result, error) in
            if let error = error {
                NSLog("error")
                completionHandlerForPreviousLocation(exists: false, errorString: "There was an error with the request: \(error)")
                return
            } else {
                guard let result = result else {
                    NSLog("Result was nil")
                    completionHandlerForPreviousLocation(exists: false, errorString: "No results were returned.")
                    return
                }
                
                guard let results = result[JSONKeys.results] as? [[String:AnyObject]] where results.count > 0 else {
                    NSLog("No previous locations for this user. \(result)")
                    completionHandlerForPreviousLocation(exists: false, errorString: "No previous locations for this user.")
                    return
                }
                NSLog("There was a previous location for this user. \(results)")
                completionHandlerForPreviousLocation(exists: true, errorString: nil)
            }
        
        }
    }
    
    func studentLocations(completionHandlerForStudentLocations: (students: [StudentLocation]?, errorString: String?) -> Void) {
        let parameters: [String: AnyObject] = [
            ParameterKeys.limit : 50,
            ParameterKeys.skip : 10,
            ParameterKeys.order : OrderKeys.descending + OrderKeys.updatedAt
        ]
        
        taskForGET(Methods.StudentLocation, parameters: parameters) { (result, error) in
            if let error = error {
                completionHandlerForStudentLocations(students: nil, errorString: "Could not find locations: \(error)")
                return
            } else {
                guard let result = result else {
                    completionHandlerForStudentLocations(students: nil, errorString: "Returned students were nil.")
                    return
                }
                self.locationsFrom(data: result, completionHandlerForConvert: completionHandlerForStudentLocations)
            }
        }
    }

    func postNewLocation() {
        
    }
    
    func updateExistingLocation() {
        
    }
    
    func locationsFrom(data data: AnyObject, completionHandlerForConvert: (result: [StudentLocation]?, errorString: String?) -> Void) {
        
        guard   let dictionary = data as? [String : AnyObject],
                let results = dictionary[JSONKeys.results] as? [[String : AnyObject]],
                let students = StudentLocation.studentLocations(results)
        else {
                completionHandlerForConvert(result: nil, errorString: "Could not parse StudentLocation from data")
                return
        }
        completionHandlerForConvert(result: students, errorString: nil)
    }
}
