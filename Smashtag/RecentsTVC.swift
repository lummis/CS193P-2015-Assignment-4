//
//  RecentsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/30/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class RecentsTVCell: UITableViewCell {           // >>>>>>>>>>>>>>> CLASS <<<<<<<<<<<<<<<
    
    @IBOutlet weak var recentSearchString: UILabel!
    @IBOutlet weak var recentSearchDate: UILabel!
    
}

class RecentsTVC: UITableViewController {        // >>>>>>>>>>>>>>> CLASS <<<<<<<<<<<<<<<

    @IBOutlet var recentsTV: UITableView!
    
    var recentSearches: [SearchHistory.Search] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recentSearches = SearchHistory.sharedHistory.history
        self.tableView.reloadData()
        self.title = "Recent Searches"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        super.numberOfSectionsInTableView(tableView)
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        
        return recentSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("recentCell", forIndexPath: indexPath) as! RecentsTVCell
        cell.recentSearchString.text = recentSearches[indexPath.row].searchString
        let searchDate = recentSearches[indexPath.row].searchDate
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(searchDate) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        cell.recentSearchDate.text = formatter.stringFromDate(searchDate)
        
        return cell
    }

}
