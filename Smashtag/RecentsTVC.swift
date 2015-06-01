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
    
//    var recentSearches: [SearchHistory.Search] = SearchHistory.sharedHistory.history {
    var recentSearches: [SearchHistory.Search] = [] {
        didSet {
            println("recentSearches/didSet; recentSearches.count: \(recentSearches.count)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshRecentSearches()
        println("RecentsTVC/viewWillAppear; recentSearches.count: \(recentSearches.count)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshRecentSearches()
        println("RecentsTVC/viewDIDAppear; recentSearches.count: \(recentSearches.count)")
    }
    
    private func refreshRecentSearches() {
        recentSearches = SearchHistory.sharedHistory.history
        println("RecentsTVC / refreshRecentSearches; recentSearches.count: \(recentSearches.count)")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        super.numberOfSectionsInTableView(tableView)
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchHistory = SearchHistory()
        return recentSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        refreshRecentSearches()
        let cell = tableView.dequeueReusableCellWithIdentifier("recentCell", forIndexPath: indexPath) as! RecentsTVCell
        let search: SearchHistory.Search = recentSearches[indexPath.row]
        cell.recentL.text = search.searchString
        
        return cell
    }
    

    
}
