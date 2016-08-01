//
//  MKPointAnnotation.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/1/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import MapKit

extension MKPointAnnotation {
    static func annotationFrom(student: StudentLocation) -> MKPointAnnotation {
        
        let lat = CLLocationDegrees(student.latitude)
        let lon = CLLocationDegrees(student.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(student.firstName) \(student.lastName)"
        annotation.subtitle = student.mediaURL
        return annotation
    }
    
    static func annotationsFrom(students: [StudentLocation]) -> [MKPointAnnotation] {
        return students.map { MKPointAnnotation.annotationFrom($0) }
    }
}
