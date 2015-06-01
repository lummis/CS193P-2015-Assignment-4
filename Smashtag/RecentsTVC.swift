//
//  RecentsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/30/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class RecentsTVCell: UITableViewCell {           // >>>>>>>>>>>>>>> CLASS <<<<<<<<<<<<<<<
    
    @IBOutlet weak var recentL: UILabel!
    
}

class RecentsTVC: UITableViewController {       // >>>>>>>>>>>>>>> CLASS <<<<<<<<<<<<<<<

    @IBOutlet var recentsTV: UITableView!

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        super.numberOfSectionsInTableView(tableView)
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchHistory = SearchHistory()
        println("recentSearches.count: \(recentSearches.count)")
        return searchHistory.history.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("recentCell", forIndexPath: indexPath) as! RecentsTVCell
        cell.recentL.text = "Hello Bunky"
        
        return cell
    }
    
    var recentSearches: [SearchHistory.Search] = SearchHistory.sharedHistory.history {
        didSet {
            println("recentSearches.count: \(recentSearches.count)")
        }
    }
    
    
}
