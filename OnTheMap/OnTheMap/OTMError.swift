//
//  OTMError.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 7/26/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

enum OTMError: ErrorType {
    case ErrorNotNil
    case NoData
    case HTTPResponse(code: Int?)
    case UnconvertableToJSON
    case KeyNotFound
    case Unsuccessful
    case AuthFail
    
    var code : Int {
        switch self {
        case .ErrorNotNil:
            return 1
        case .NoData:
            return 2
        case .UnconvertableToJSON:
            return 3
        case .KeyNotFound:
            return 4
        case .Unsuccessful:
            return 5
        case .AuthFail:
            return 6
        case .HTTPResponse(let _code):
            return _code ?? -1
        }
    }
    
}
