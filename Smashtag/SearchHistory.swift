//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/31/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class SearchHistory {
    
    // "SearchHistory.sharedHistory" is a singleton. requires Swift >= 1.2
    static let sharedHistory = SearchHistory()
    
    struct Search {
        let searchString: String
        let searchDate: NSDate
    }
    
    var history = [Search]()
    
    // why is init called 5 times???
    init() {
        // from userDefaults get array of NSStrings and array of NSDates
        // convert to Search structs and put in history array
        let store = NSUserDefaults.standardUserDefaults()
        let searchStrings = store.objectForKey("searchStrings") as? [String]
        let searchDates = store.objectForKey("searchDates") as? [NSDate]
        
        if searchStrings != nil && searchDates != nil && searchDates!.count == searchStrings!.count {
            // searchStrings and searchDates should have the same number of elements
            for i in 0..<searchStrings!.count {
                let search = Search(searchString: searchStrings![i], searchDate: searchDates![i])
                history.append(search)
            }
        } else { println("SearchHistory/init; searchStrings and/or searchDates not valid") }
    }
    
    // given a search term as a String, delete an item with that string from history if it's there
    // make a new item by adding the current date, insert it as history[0]
    // update userDefaults
    func addSearchToHistory(string: String) {
        history = history.filter { return $0.searchString != string }
        let searchItem = Search(searchString: string, searchDate: NSDate())
        history.insert(searchItem, atIndex: 0)
        storeHistory()
    }
    
    // store history array in userDefaults
    // the searchStrings and searchDates have to be stored separately because userDefaults
    // can only store property list items so array of NSStrings and array of NSDates are ok
    // but array of tuples is not
    private func storeHistory() {
        var searchStrings = [NSString]()
        var searchDates = [NSDate]()
        for h in history {
            searchStrings.append(h.searchString as NSString)
            searchDates.append(h.searchDate)
        }
        let store = NSUserDefaults.standardUserDefaults()
        store.setObject(searchStrings, forKey: "searchStrings")
        store.setObject(searchDates, forKey: "searchDates")
        store.synchronize() // probably not needed
    }
}