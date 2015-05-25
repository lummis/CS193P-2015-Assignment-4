//
//  MentionsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/12/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

//  This class deals with just a single tweet

import UIKit

private struct MentionsConstants {
    static let CellReuseIdentifier = "mention"
    static let ImageViewIdentifier = "imageVC"
}

class MentionsTVC: UITableViewController, UITableViewDelegate {
    
    var aspectRatio: CGFloat = 1
    var hasImage: Bool = false
    var imageURL: NSURL?
    var mentions: [TweetTableViewController.MentionedItems]! {
        didSet {
            for mention in mentions {
                switch mention {
                case .MediaItems:
                    hasImage = true
                default:
                    break
                }
            }
        }
    }
    var textForNextSearch: String!  // copied to TweetTableViewController during unwind segue
    
    // MARK: - Table view delegate
    
    // if an image is present it will always be in row 0
    // the code has an array of .MediaItems so there could be more than one
    // but we will only show the first image
    // in practice there seems to never be more than one. Maybe twitter doesn't support >1.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && hasImage {
            return 100.0 / aspectRatio
        } else { return UITableViewAutomaticDimension }
    }
    
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if imageURL != nil && indexPath.section == 0 {
                displayImage(imageURL!)
                return
        }
        
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

    func displayImage(imageURL: NSURL) {
        let imageVC = storyboard?.instantiateViewControllerWithIdentifier(MentionsConstants.ImageViewIdentifier) as! ImageVC
        if let imageData = NSData(contentsOfURL: imageURL) {
            imageVC.imageView = UIImageView(image: UIImage(data: imageData))
            showViewController(imageVC, sender: self)
        }
    }

    // this allows reloadData() to be called
    // if reloadData isn't called the row heights are wrong after the first device rotation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("rotate")
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mentions[section] {
        case .UrlItems( let items ):
            return items.count
        case .UserItems( let items ):
            return items.count
        case .MediaItems( let items):
            return items.count
        case .HashtagItems( let items ):
            return items.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell
        cell.imageV.hidden = true           // reverse for image case
        cell.mentionLabel1.hidden = false   // reverse for image case
        
        switch mentions[indexPath.section] {
            
        case .UserItems(let items):
            cell.mentionLabel1.text = items[indexPath.row]

        case .HashtagItems(let items):
            cell.mentionLabel1.text = items[indexPath.row]

        case .UrlItems(let items):
            cell.mentionLabel1.text = items[indexPath.row]

        case .MediaItems(let items):
            let image = items[0]
            imageURL = image.url    // for segue
            let url = image.url
            if let imageData = NSData(contentsOfURL: url) {
                cell.imageV.image = UIImage(data: imageData)
            }
            cell.imageV.hidden = false
            cell.mentionLabel1.hidden = true
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
