//
//  UdacityClientConvenience.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginWithPassword(creds: (username: String, password: String), completionHandlerForLogin: (success: Bool, errorString: String?) -> Void) {
        taskForPOST(Methods.session, jsonBody: postBody(username: creds.username, password: creds.password)) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForLogin(success: false, errorString: "Login Failed (POST Session)")
            } else {
                self.getSessionInfo(result, completionHandlerForSession: completionHandlerForLogin)
            }
        }
    }
    
    func loginWithFB(fbID: String, completionHandlerForFBLogin: (success: Bool, errorString: String?) -> Void) {
        taskForPOST(Methods.session, jsonBody: postBody(fbID)) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForFBLogin(success: false, errorString: "Login Failed (POST Session)")
            } else {
                self.getSessionInfo(result, completionHandlerForSession: completionHandlerForFBLogin)
            }
        }
    }
    
    func getSessionInfo(data: AnyObject?, completionHandlerForSession: (success: Bool, errorString: String?) -> Void) {
        guard let json = data as? [[String: AnyObject]] else {
            completionHandlerForSession(success: false, errorString: "Data did not come back in the right format")
            return
        }
        
        for object in json where (object[JSONKeys.account] as? [String: AnyObject]) != nil {
            guard   let account = object[JSONKeys.account] as? [String: AnyObject],
                    let registered = account[JSONKeys.registered] as? Bool,
                    let key = account[JSONKeys.key] as? String else {
                    completionHandlerForSession(success: false, errorString: "Could not parse account from response")
                    return
            }
            if registered {
                self.account.accountID = key
            } else {
                completionHandlerForSession(success: false, errorString: "Cannot login with unregistered user")
                return
            }
        }
        
        for object in json where (object[JSONKeys.session] as? [String: AnyObject]) != nil {
            guard   let session = object[JSONKeys.session] as? [String: AnyObject],
                    let sessionid = session[JSONKeys.id] as? String else {
                    completionHandlerForSession(success: false, errorString: "Cannot parse session.")
                    return
            }
            self.sessionID = sessionid
        }
        completionHandlerForSession(success: true, errorString: nil)
    }
  
    // MARK: Helpers
    
    private func postBody(username username: String, password: String) -> String {
        return "{\"\(POSTBody.udacity)\":{\"\(POSTBody.username)\":\"\(username)\",\"\(POSTBody.password)\":\"\(password)\"}}"
    }
    
    private func postBody(fbID: String) -> String {
        return "{\"\(POSTBody.facebookmobile)\":\"\(POSTBody.access_token)\":\"\(fbID)\"}"
    }
    

}
