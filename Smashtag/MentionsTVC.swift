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
    
    var aspectRatio: CGFloat = 1
    var mentions: [TweetTableViewController.MentionedItems]!
    var textForNextSearch: String!  // copied to TweetTableViewController during unwind segue
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if aspectRatio == 0.0 { return 100.0 }
            return 100.0 / aspectRatio
        default:
            return UITableViewAutomaticDimension
        }
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
            let theURL: NSURL = NSURL(string: cellText)!
            UIApplication.sharedApplication().openURL(theURL)
            
        default:
            println("switch didn't get # or @ or h")
            break
        }

    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        let array = mentions[section]
        switch array {
        case .UserItems(let userMentions):
            return userMentions.count
        case .HashtagItems(let hashtagMentions):
            return hashtagMentions.count
        case .UrlItems(let urlMentions):
            return urlMentions.count
        case .MediaItems(let mediaMentions):
            return mediaMentions.count
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell
        let sectionItems = mentions[indexPath.section]
        
        cell.imageV.hidden = true   // reverse for image case
        cell.mentionLabel1.hidden = false   // reverse for image case
        
        switch sectionItems {
            
        case .UserItems(let userMentions):
            cell.mentionLabel1.text = userMentions[indexPath.row]

        case .HashtagItems(let hashtags):
            cell.mentionLabel1.text = hashtags[indexPath.row]

        case .UrlItems(let urls):
            cell.mentionLabel1.text = urls[indexPath.row]

        case .MediaItems(let images):
            cell.imageV.hidden = false
            cell.mentionLabel1.hidden = true
            let image = images[0]
            let url = image.url
            if let imageData = NSData(contentsOfURL: url) {
                cell.imageV.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var word = ""
        switch mentions[section] {
        case .UserItems:
            word = "Screen Names"
        case .HashtagItems:
            word = "Hashtags"
        case .UrlItems:
            word = "URLs"
        case .MediaItems:
            word = "Images"
        }
        return word
    }
    
//    // required if viewForHeaderInSection is implemented
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
////     if implemented overrides the header text given in ...titleForHeaderInSection
////     I'm implementing this so I can specify colors
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        super.tableView(tableView, viewForHeaderInSection: section)
//        let view: UILabel = UILabel( frame: CGRectNull )    // size will be overridden by tableView
//        view.backgroundColor = UIColor.lightGrayColor()
//        view.textColor = UIColor.whiteColor()
//
//        var sectionHeader = ""
//        switch mentions[section] {
//        case .UserItems(let userMentions):
//            sectionHeader = "Users"
//        case .HashtagItems(let hashtagMentions):
//            sectionHeader = "Hashtags"
//        case .UrlItems(let urlMentions):
//            sectionHeader = "URLs"
//        case .MediaItems(let mediaMentions):
//            sectionHeader = "Images"
//        }
//        view.text = sectionHeader
//        return view
//    }

}
