//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Joshua Kelley on 8/1/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

class ListViewController : UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var data = StudentDataSource.sharedInstance.students
    
    // MARK: Outlets
    
    // MARK: Actions
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StudentDataSource.sharedInstance.dataUpdatedMap = dataUpdated
        
        self.tabBarController?.tabBar.hidden = false
        tableView.delegate = self
        tableView.dataSource = StudentDataSource.sharedInstance
        
    }
    
    // MARK: - Custom Methods
    
    func dataUpdated() {
        UI.performUIUpdate {
            self.tableView.reloadData()
            print("update called from data source")
        }
    }
}

extension ListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlString = StudentDataSource.sharedInstance.students[indexPath.row].mediaURL
        guard let url = NSURL(string: urlString) else {
            NSLog("URLString (\(urlString)) from Student could not form a URL!")
            return
        }
        url.openInSafari()
    }
}
