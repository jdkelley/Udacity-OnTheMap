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
    
//    func previousLocation(uniqueKey uniqueKey: String) {
//        let parameters: [String: AnyObject] = [
//            ParameterKeys.Where: ParameterKeys.whereClause(uniqueKey)
//        ]
//        
//        func completion(exists exists: Bool, errorString: String?) {
//            if exists {
//                NSLog("Previous Location Exists!")
//                UdacityClient.sharedInstance.account.hasPreviousUpload = true
//            } else {
//                NSLog("Previous Location Does not exist!")
//                UdacityClient.sharedInstance.account.hasPreviousUpload = false
//            }
//        }
//        
//        taskForGET(Methods.StudentLocation, parameters: parameters) { (result, error) in
//            if let error = error {
//                NSLog("error")
//                completion(exists: false, errorString: "There was an error with the request: \(error)")
//                return
//            } else {
//                guard let result = result else {
//                    NSLog("Result was nil")
//                    completion(exists: false, errorString: "No results were returned.")
//                    return
//                }
//                
//                guard let results = result[JSONKeys.results] as? [[String:AnyObject]] where results.count > 0 else {
//                    NSLog("No previous locations for this user. \(result)")
//                    completion(exists: false, errorString: "No previous locations for this user.")
//                    return
//                }
//                NSLog("There was a previous location for this user. \(results)")
//                completion(exists: true, errorString: nil)
//            }
//        }
//    }
    
    func studentLocations(completionForLoginFlow: ((success: Bool, errorString: String?) -> Void)? = nil, uiCompletion: (() -> Void)? = nil) {
        let parameters: [String: AnyObject] = [
            ParameterKeys.limit : 100,
            ParameterKeys.skip : 0,
            ParameterKeys.order : "-"+OrderKeys.updatedAt
        ]
        
        taskForGET(Methods.StudentLocation, parameters: parameters) { (result, error) in
            if let error = error {
                NSLog("Could not find locations: \(error)")
                completionForLoginFlow?(success: false, errorString: "Could not find locations: \(error)")
                return
            } else {
                guard let result = result else {
                    NSLog("Returned students were nil.")
                    completionForLoginFlow?(success: false, errorString: "Returned students were nil.")
                    return
                }
                self.locationsFrom(data: result, completionForLoginFlow: completionForLoginFlow, uiCompletionHandlerForConvert: uiCompletion)
            }
        }
    }

    func postNewLocation(mediaURL mediaURL: String, mapString: String, lat: Double, long: Double, uiCompletion: ((errorString: String?) -> Void)? = nil) {
        
        let client = UdacityClient.sharedInstance
        
        guard  let firstName = client.account.firstName,
               let lastName = client.account.lastName,
               let accountID = client.account.accountID
        else {
               NSLog("Could not parse student location from Account.")
               return
        }
        
        let body = StudentLocation(uniqueKey: accountID, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: lat, longitude: long, objectID: "N/A").JSONObjectFor(uniqueKey: accountID)
        
        taskForPOST(ParseClient.Methods.StudentLocation, parameters: [:], jsonBody: body) { (result, error) in
            if let error = error {
                NSLog("Could not find locations: \(error)")
                //completionForLoginFlow?(success: false, errorString: "Could not find locations: \(error)")
                uiCompletion?(errorString: "Could not find locations: \(error)")
                return
            } else {
                guard let result = result as? [String: AnyObject] else {
                    uiCompletion?(errorString: "Returned students were nil.")
                    return
                }
                
                guard let objectID = result[JSONKeys.objectId] as? String where objectID != "" else {
                    uiCompletion?(errorString: "Post Corrupted.")
                    return
                }
                uiCompletion?(errorString: nil)
            }
        }
    }
    
    func locationsFrom(data data: AnyObject, completionForLoginFlow: ((success: Bool, errorString: String?) -> Void)? = nil, uiCompletionHandlerForConvert: (() -> Void)? = nil) {
        
        guard   let dictionary = data as? [String : AnyObject],
                let results = dictionary[JSONKeys.results] as? [[String : AnyObject]],
                let students = StudentLocation.studentLocations(results)
        else {
                NSLog("Could not parse StudentLocation from data")
            completionForLoginFlow?(success: false, errorString: "Could not parse StudentLocation from data")
                return
        }
        StudentDataSource.sharedInstance.students = students
        completionForLoginFlow?(success: true, errorString: nil)
        uiCompletionHandlerForConvert?()
    }
}
