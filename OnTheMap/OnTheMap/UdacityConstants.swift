//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    static let SignUp = "https://www.udacity.com/account/auth#!/signup"

    struct Constants {
        static let apiScheme = "https"
        static let apiHost = "www.udacity.com"
        static let apiPath = "/api"
    }
    
    struct Cookie {
        static let name = "XSRF-TOKEN"
    }
    
    struct HeaderKey {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XXSRFTOKEN = "X-XSRF-TOKEN"
    }
    
    struct HeaderValue {
        static let ApplicationJSON = "application/json"
    }
    
    struct Methods {
        static let session = "/session"
        static let users = "/users/{user_id}"
    }
    
    struct URLKey {
        static let userid = "user_id"
    }
    
    struct POSTBody {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let facebookmobile = "facebook_mobile"
        static let access_token = "access_token"
    }
    
    struct JSONKeys {
        static let account = "account"
        static let session = "session"
        static let registered = "registered"
        static let key = "key"
        static let id = "id"
        static let expiration = "expiration"
        static let lastname = "last_name"
        static let firstname = "first_name"
    }
    
    struct Domain {
        static let taskForPOST = "UdacityClient.taskForPOST"
        static let taskForGET = "UdacityClient.taskForGET"
        static let taskForDELETE = "UdacityClient.taskForDELETE"
        static let convertDataWithCompletionHandler = "UdacityClient.convertDataWithCompletionHandler"
    }
}
