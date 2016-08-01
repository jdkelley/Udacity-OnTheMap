//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension ParseClient {

    struct Constants {
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let apiScheme = "https"
        static let apiHost = "api.parse.com"
        static let apiPath = "/1/classes"
    }
    
    struct HeaderKey {
        static let XParseAppID = "X-Parse-Application-Id"
        static let XParseAPIKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    struct HeaderValue {
        static let ApplicationJSON = "application/json"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let StudentLocationObjectID = "/StudentLocation/{objectId}"
    }
    
    struct URLKeys {
        static let objectId = "objectId"
    }
    
    struct ParameterKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        static let Where = "where"
        static func whereClause(uniqueKey: String) -> String {
            return "{\"\(OrderKeys.uniqueKey)\":\"\(uniqueKey)\"}"
        }
    }
    
    struct OrderKeys {
        static let descending: String = "-"
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

    struct JSONKeys {
        static let results = "results"
    }
    
    
}
