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

//var tweet: Tweet! {
//    didSet {
//        println("MentionsTVC; didSet tweet")
//    }
//}

//private enum Mention {
//    case Image (UIImage)
//    case URL (String)
//    case Hashtag (String)
//    case User (String)
//    
//    var description: String {
//        get {
//            switch self {
//            case .Image (let image):
//                return "someImage"
//            case .URL (let url):
//                return url
//            case .Hashtag (let tag):
//                return tag
//            case .User (let user):
//                return user
//            }
//        }
//    }
//}

class MentionsTVC: UITableViewController {
    
//    var delegate: TweetTableViewController!
    
//    struct MentionedItems {
//        var type: String
//        var items: [String]
//    }
    
    var mentions: [TweetTableViewController.MentionedItems]! {
        didSet {
            println("hello")
        }
    }
    
//    var tweet: Tweet? {
//        didSet {
//            println("MentionsTVC/didSet tweet")
//
//        }
//    }
    
//    override func viewDidLoad() {
//        mentions = delegate.mentions
//    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        println("MentionsTVC/viewDidAppear; tweet: \(tweet)  title: \(title)")
//    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected section \(indexPath.section), row \(indexPath.row)")
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = mentions[section].items
        return items.count
    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tweet != nil {
//            switch section {
//            case 0:
//                return tweet!.media.count
//            case 1:
//                return tweet!.hashtags.count
//            case 2:
//                return tweet!.urls.count
//            case 3:
//                return tweet!.userMentions.count
//            default:
//                break
//            }
//        }
//        return 5
//    }
    
    // provides the header text if tableView(tableView: UITableView, viewForHeaderInSection section: Int) doesn't override it
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionHeaders[section]
        return mentions[section].type
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell
        let sectionItems = mentions[indexPath.section]
        cell.mentionLabel1.text = sectionItems.items[indexPath.row]
        return cell
    }

    // if implemented overrides the header text given in ...titleForHeaderInSection
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        super.tableView(tableView, viewForHeaderInSection: section)
//        println("section: \(section)")
//
//        let view: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
//        view.backgroundColor = UIColor.yellowColor()
//        let sectionNumberL = UILabel()
//        sectionNumberL.text = "Section \(section)"
//        sectionNumberL.frame = CGRectMake(10, 10, 100, 15)
//        view.addSubview(sectionNumberL)
//        return view
//
//    }

}
