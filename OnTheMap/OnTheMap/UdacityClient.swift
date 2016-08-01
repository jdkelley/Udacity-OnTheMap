//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

class UdacityClient {
    
    let account = Account()
    var sessionID: String?
    
    
    // MARK: - Singleton
    static let sharedInstance = UdacityClient()
    private init() {}
    
    // MARK: GET
    
    func taskForGET(method: String, completionHandlerForGET: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let request = NSMutableURLRequest(URL: udacityURLWith(pathExtention: method))
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String, code: OTMError) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: Domain.taskForGET, code: code.code, userInfo: userInfo))
            }
            
            
            guard error == nil else {
                sendError("There was an error with your request: \(error!)", code: .ErrorNotNil)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200  && statusCode < 300 else {
                sendError("Request returned something other than a 2xx response.", code: .HTTPResponse(code: (response as? NSHTTPURLResponse)?.statusCode))
                return
            }
            
            guard let data = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) else {
                sendError("No Data was returned from your request.", code: .NoData)
                return
            }
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        return task
    }
    
    // MARK: POST
    
    func taskForPOST(method: String, jsonBody: String, completionHandlerForPost: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = udacityURLWith(pathExtention: Methods.session)
        print("URL : \(url)")
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTPMethod.POST.rawValue
        request.addValue(HeaderValue.ApplicationJSON, forHTTPHeaderField: HeaderKey.Accept)
        request.addValue(HeaderValue.ApplicationJSON, forHTTPHeaderField: HeaderKey.ContentType)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String, code: OTMError) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(result: nil, error: NSError(domain: Domain.taskForPOST, code: code.code, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error with your request: \(error)", code: .ErrorNotNil)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200  && statusCode < 300 else {
                sendError("Request returned something other than a 2xx response.", code: .HTTPResponse(code: (response as? NSHTTPURLResponse)?.statusCode))
                return
            }
            
            guard let data = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) else {
                sendError("No Data was returned from your request.", code: .NoData)
                return
            }
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        task.resume()
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETE(method: String, completionHandlerForDELETE: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: udacityURLWith(pathExtention: Methods.session))
        request.HTTPMethod = HTTPMethod.DELETE.rawValue
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Cookie.name { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: HeaderKey.XXSRFTOKEN)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String, code: OTMError) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(result: nil, error: NSError(domain: Domain.taskForDELETE, code: code.code, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error with your request.", code: .ErrorNotNil)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode < 300 else {
                sendError("Request returned something other than a 2xx response.", code: .HTTPResponse(code: (response as? NSHTTPURLResponse)?.statusCode))
                return
            }
            
            guard let _ = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) else {
                sendError("No data was returned from your request.", code: .NoData)
                return
            }
        }
        
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(data data: NSData, completionHandlerForConvertData: (result: AnyObject?, NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(result: nil, NSError(domain: Domain.convertDataWithCompletionHandler, code: OTMError.UnconvertableToJSON.code, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, nil)
    }
    
    // MARK: Helpers 
    
    private func udacityURLWith(pathExtention path: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath + (path ?? "")
        return components.URL!
    }

}
