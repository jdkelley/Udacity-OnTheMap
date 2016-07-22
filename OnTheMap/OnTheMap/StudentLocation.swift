//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/21/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
   
    struct JSONKeys {
        static let objectId: String = "objectId"
        static let uniqueKey: String = "uniqueKey"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        
        static let createdAt: String = "createdAt"
        static let updatedAt: String = "updatedAt"
        static let ACL: String = "ACL"
    }
    
    // MARK: Deserialization
    
    static func studentLocation(from: [String: AnyObject]) -> StudentLocation? {
        guard   let object = from[JSONKeys.objectId] as? String,
                let unique = from[JSONKeys.uniqueKey] as? String,
                let first = from[JSONKeys.firstName] as? String,
                let last = from[JSONKeys.lastName] as? String,
                let map = from[JSONKeys.mapString] as? String,
                let url = from[JSONKeys.mediaURL] as? String,
                let lat = from[JSONKeys.latitude] as? Double,
                let lon = from[JSONKeys.longitude] as? Double
        else {
            NSLog("Could not parse StudentLocation from: \(from)")
            return nil
        }
        
        return StudentLocation(objectId: object, uniqueKey: unique, firstName: first, lastName: last, mapString: map, mediaURL: url, latitude: lat, longitude: lon)
    }
    
    static func studentLocations(from: [[String: AnyObject]]) -> [StudentLocation]? {
        return from.flatMap {self.studentLocation($0)}
    }
    
    // MARK: Serialization 
    
    
    
}
