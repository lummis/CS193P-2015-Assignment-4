//
//  MentionsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/12/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

private struct MentionsConstants {
    static let CellReuseIdentifier = "mention"
}

class MentionsTVC: UITableViewController, UITableViewDelegate {
    
    var mentions: [TweetTableViewController.MentionedItems]!
    var textForNextSearch: String!  // copied to TweetTableViewController during unwind segue
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MentionsTableViewCell
        let cellText = cell.mentionLabel1.text!
        let firstChar = cellText[cellText.startIndex]
        switch firstChar {
            case "#", "@":
            textForNextSearch = cellText
            performSegueWithIdentifier("unwindToTweets", sender: self)
            
        case "h":
            println("going to url: \(cellText)")
            let theURL: NSURL = NSURL(string: cellText)!
            UIApplication.sharedApplication().openURL(theURL)
            
        default:
            break
        }

//
//        let label = cell.mentionLabel1
//        textForNextSearch = label.text
//        performSegueWithIdentifier("unwindToTweets", sender: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = mentions[section].items
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell
        let sectionItems = mentions[indexPath.section]
        cell.mentionLabel1.text = sectionItems.items[indexPath.row]
        return cell
    }
    
    // required if viewForHeaderInSection is implemented
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    // if implemented overrides the header text given in ...titleForHeaderInSection
    // I'm implementing this so I can specify colors
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        super.tableView(tableView, viewForHeaderInSection: section)
        let view: UILabel = UILabel( frame: CGRectNull )    // size will be overridden by tableView
        view.backgroundColor = UIColor.lightGrayColor()
        view.textColor = UIColor.whiteColor()
        view.text = mentions[section].typeName
        return view
    }

}
