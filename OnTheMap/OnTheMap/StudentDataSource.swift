//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/1/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import MapKit

class StudentDataSource : NSObject {
    
    // MARK: Shared Instance
    static let sharedInstance = StudentDataSource()
    private override init() {}
    
    // MARK: Properties
    var students = [StudentLocation]() {
        didSet {
            setAnnotationsWith(students)
        }
    }
    
    var annotations = [MKPointAnnotation]()
}

// MARK: Helpers

extension StudentDataSource {
    func setAnnotationsWith(students: [StudentLocation]) {
        annotations = MKPointAnnotation.annotationsFrom(students)
    }
    
    func clearMapData() {
        students = [StudentLocation]()
        annotations = [MKPointAnnotation]()
    }
}

extension StudentDataSource : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.OTMTableViewCell) else {
            return UITableViewCell()
        }
        
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: Identifiers.OTMTableViewCell)
        cell.textLabel?.text = "\(students[index].firstName) \(students[index].lastName)"
        cell.detailTextLabel?.text = students[index].mediaURL
        return cell
    }
}
