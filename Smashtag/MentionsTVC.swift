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

class MentionsTVC: UITableViewController {
    
    var tweet: Tweet? {
        didSet {
            println("MentionsTVC/didSet tweet")
        }
    }

    let sectionHeaders = ["Images", "Hashtags", "URLs", "User Screen Names"]
    
    override func viewDidLoad() {
        println("MentionsTVC/viewDidLoad;")
        super.viewDidLoad()
        if tweet != nil {
            self.title = tweet?.user.name
        } else {
            println("tweet == nil")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("MentionsTVC/viewDidAppear; tweet: \(tweet)  title: \(title)")
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected section \(indexPath.section), row \(indexPath.row)")
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweet != nil {
            switch section {
            case 0:
                return tweet!.media.count
            case 1:
                return tweet!.hashtags.count
            case 2:
                return tweet!.urls.count
            case 3:
                return tweet!.userMentions.count
            default:
                break
            }
        }
        return 5
    }
    
    // provides the header text if tableView(tableView: UITableView, viewForHeaderInSection section: Int) doesn't override it
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell

//        cell.mentionLabel1.text = "IndexPath.row: \(indexPath.row)"
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
