//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/31/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class SearchHistory {
    
    static let sharedHistory = SearchHistory()  // make "sharedHistory" singleton. requires Swift >= 1.2
    
    struct Search {
        let searchString: String
        let searchDate: NSDate
    }
    
    var history = [Search]()
    
    init() {
        // fill history array with the recent searches, if there are any
        let store = NSUserDefaults.standardUserDefaults()
        let searchStrings = store.objectForKey("searchStrings") as? [String]
        let searchDates = store.objectForKey("searchDates") as? [NSDate]
        
        if searchStrings != nil && searchDates != nil {
            // searchStrings and searchDates should have the same number of elements
            for i in 0..<searchStrings!.count {
                let search = Search(searchString: searchStrings![i], searchDate: searchDates![i])
                history.append(search)
            }
        }
        
        println("SearchHistory.init; history.count: \(history.count)")
    }
    
    // given a search term as a String, add it as history[0] 
    // and store it in user defaults along with the current date
    // if the string is the same as a string that was previously searched, 
    // delete the old one from history
    func storeSearch(string: String) {
        let searchItem = Search(searchString: string, searchDate: NSDate())
        history.insert(searchItem, atIndex: 0)
        storeHistory()
    }
    
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
    }
}