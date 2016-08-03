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
    
    // MARK: Outlets
    
    // MARK: Actions
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        tableView.delegate = self
        tableView.dataSource = StudentDataSource.sharedInstance
        
    }
    
    // MARK: - Custom Methods
    
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
