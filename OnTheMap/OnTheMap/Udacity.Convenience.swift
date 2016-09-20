//
//  Udacity.Convenience.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func deleteSessionInfo(completionHandler: (() -> Void)) {
        NSLog("I am trying to delete the session info")
        taskForDELETE(Methods.session) { (result, error) in
            if let error = error {
                NSLog("\(error)")
            } else {
                guard let json = result as? [String: AnyObject] else {
                    NSLog("Logout failed. Could not delete Session Token")
                    return
                }
                NSLog("Deleting Token: \(json)")
                UdacityClient.sharedInstance.account.reset()
                UdacityClient.sharedInstance.sessionID = nil
                completionHandler()
            }
        }
    }
    
    func loginWithPassword(creds: (username: String, password: String), completionHandlerForLogin: (success: Bool, errorString: String?) -> Void) {
        taskForPOST(Methods.session, jsonBody: postBody(username: creds.username, password: creds.password)) { (result, error) in
            if let error = error {
                NSLog("\(error)")
                if error.code == 403  {
                    completionHandlerForLogin(success: false, errorString:  LoginMessages.InvalidEmail )
                } else {
                    completionHandlerForLogin(success: false, errorString: LoginMessages.LoginFailedOnPost)
                }
            } else {
                self.getSessionInfo(result, completionHandlerForSession: completionHandlerForLogin)
            }
        }
    }
    
    func loginWithFB(fbID: String, completionHandlerForFBLogin: (success: Bool, errorString: String?) -> Void) {
        taskForPOST(Methods.session, jsonBody: postBody(fbID)) { (result, error) in
            if let error = error {
                NSLog("\(error)")
                if error.code == 403  {
                    completionHandlerForFBLogin(success: false, errorString:  LoginMessages.InvalidEmail )
                } else {
                    completionHandlerForFBLogin(success: false, errorString: LoginMessages.LoginFailedOnPost)
                }
            } else {
                self.getSessionInfo(result, completionHandlerForSession: completionHandlerForFBLogin)
            }
        }
    }
    
    func getSessionInfo(data: AnyObject!, completionHandlerForSession: (success: Bool, errorString: String?) -> Void) {
        guard let json = data as? [String: AnyObject] else {
            completionHandlerForSession(success: false, errorString: "Data did not come back in the right format \(data)")
            return
        }
        guard   let account = json[JSONKeys.account] as? [String: AnyObject],
                let session = json[JSONKeys.session] as? [String: AnyObject],
                let sessionid = session[JSONKeys.id] as? String,
                let registered = account[JSONKeys.registered] as? Bool,
                let key = account[JSONKeys.key] as? String
        else {
                completionHandlerForSession(success: false, errorString: LoginMessages.InvalidEmail)
                return
        }
        if registered {
            self.account.accountID = key
        } else {
            completionHandlerForSession(success: false, errorString: LoginMessages.InvalidEmail)
            return
        }
        self.sessionID = sessionid
        
        getUserData(completionHandlerForSession)
        
        //completionHandlerForSession(success: true, errorString: nil)
    }
    
    func getUserData(completionForGetUserData: (success: Bool, errorString: String?) -> Void) {
        let method = Methods.users.substitute(key: URLKey.userid, forValue: self.account.accountID!) ?? ""
        self.taskForGET(method, completionHandlerForGET: { (result, error) in
            if let _ = error {
                NSLog("There was an error downloading the user info the the current user.")
                completionForGetUserData(success: false, errorString: LoginMessages.ErrorDownloadingUserInfo)
            } else {
                if  let result = result as? [String: AnyObject],
                    let user = result[JSONKeys.user] as? [String: AnyObject],
                    let last = user[JSONKeys.lastname] as? String,
                    let first = user[JSONKeys.firstname] as? String {
                    self.account.firstName = first
                    self.account.lastName = last
                    
                    ParseClient.sharedInstance.studentLocations({ (success, errorString) in
                        if success {
                            completionForGetUserData(success: success, errorString: nil)
                        } else {
                            completionForGetUserData(success: false, errorString: errorString ?? "")
                        }
                        
                    })
                    
                } else {
                    NSLog("There was an error downloading the user info the the current user.")
                    completionForGetUserData(success: false, errorString: LoginMessages.ErrorDownloadingUserInfo)
                }
            }
        })
    }
  
    // MARK: Helpers
    
    private func postBody(username username: String, password: String) -> String {
        return "{\"\(POSTBody.udacity)\":{\"\(POSTBody.username)\":\"\(username)\",\"\(POSTBody.password)\":\"\(password)\"}}"
    }
    
    private func postBody(fbID: String) -> String {
        return "{\"\(POSTBody.facebookmobile)\":{\"\(POSTBody.access_token)\":\"\(fbID)\"}}"
    }
    

}
