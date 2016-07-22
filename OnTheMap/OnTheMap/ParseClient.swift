//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

class ParseClient {
    
    var sessionID: String?
    
    
    // MARK: - Singleton
    static let sharedInstance = ParseClient()
    private init() {}
    
    // MARK: GET
    
    func taskForGET(method: String, parameters: [String : AnyObject], completionHandlerForGET: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = requestWith(url: parseURLFrom(parameters: parameters, withPathExtension: method), method: .GET)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGET", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned with your request!")
                return
            }
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        return task
    }
    
    // MARK: POST
    
    func taskForPOST(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = requestWith(url: parseURLFrom(parameters: parameters, withPathExtension: method), method: .POST)
        request.addValue(HeaderValue.ApplicationJSON, forHTTPHeaderField: HeaderKey.ContentType)
        request.HTTPBody = "".dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOST", code: 1, userInfo: userInfo))
            }
            
            
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned with your request!")
                return
            }
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    // MARK: PUT
    
    func taskForPUT(method: String, jsonBody: String, completionHandlerForPUT: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = requestWith(url: parseURLFrom(parameters: [:], withPathExtension: method), method: .PUT)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String){
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPUT", code: 1, userInfo: userInfo))
            }
            
            
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned with your request!")
                return
            }
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Helpers
    
    private func parseURLFrom(parameters parameters: [String : AnyObject], withPathExtension: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath + (withPathExtension ?? "")
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func convertDataWithCompletionHandler(data data: NSData, completionHandlerForConvertData: (result: AnyObject?, NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(result: nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, nil)
    }
    
    private func requestWith(url url: NSURL, method: HTTPMethod) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.addValue(Constants.AppID, forHTTPHeaderField: HeaderKey.XParseAppID)
        request.addValue(Constants.APIKey, forHTTPHeaderField: HeaderKey.XParseAPIKey)
        return request
    }
}


