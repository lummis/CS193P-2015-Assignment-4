//
//  MentionsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/12/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

//  This class shows details for a single tweet

import UIKit

private struct MentionsConstants {
    static let ImageViewIdentifier = "imageVC"
    static let ImageCellIdentifier = "imageCell"
    static let TextCellIdentifier = "textCell"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"deviceDidRotate", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()  // seems to be needed else row heights are wrong
    }
    
    func deviceDidRotate() {
        // if reloadData isn't called the row heights revert to storyboard heights instead of autoLayout
        tableView.reloadData()
    }
    
    // MARK: - Table view delegate
    
    // if an image is present it will always be in row 0
    // the twitter API has an array of .MediaItems so there could be more than one
    // but we show the first image; in practice there seems to never be more than one
    // maybe twitter doesn't support >1.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && hasImage {
            return 100.0 / aspectRatio
        } else { return UITableViewAutomaticDimension }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {                          // ????????????????
        
        if imageURL != nil && indexPath.section == 0 {
            displayImage(imageURL!)
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextMentionCell
        let cellText = cell.mentionText.text!   // ! is so cellText is not an optional, so startIndex can be used on it
        let firstChar = cellText[cellText.startIndex]
        switch firstChar {
            case "#", "@":
            textForNextSearch = cellText
            performSegueWithIdentifier("unwindToSearches", sender: self)
            
        case "h":
            let theURL: NSURL = NSURL(string: cellText)!
            UIApplication.sharedApplication().openURL(theURL)
            
        default:
            println("switch didn't get # or @ or h")
            break
        }
    }

//    func displayImage(imageURL: NSURL) {
//        let imageVC = storyboard?.instantiateViewControllerWithIdentifier(MentionsConstants.ImageViewIdentifier) as! ImageVC
////        let imageVC = storyboard?.instantiateViewControllerWithIdentifier("navcon_image") as! ImageVC
//        let qos = Int(QOS_CLASS_USER_INITIATED.value)
//        let queue = dispatch_get_global_queue(qos, 0)
//        dispatch_async(queue) {
//            if let imageData = NSData(contentsOfURL: imageURL) {
//                dispatch_async(dispatch_get_main_queue()) {
//                    imageVC.imageView = UIImageView(image: UIImage(data: imageData))
//                    imageVC.title = "Image"
//                    self.showViewController(imageVC, sender: self)
//                }
//            }
//        }
//    }
    
    func displayImage(imageURL: NSURL) {                                                                                            // ????????????????
        let imageVC = storyboard?.instantiateViewControllerWithIdentifier(MentionsConstants.ImageViewIdentifier) as! ImageVC
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            if let imageData = NSData(contentsOfURL: imageURL) {
                dispatch_async(dispatch_get_main_queue()) {
                    imageVC.imageView = UIImageView(image: UIImage(data: imageData))
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // is there a more succinct way to write this?
        switch mentions[section] {
        case .UrlItems( let items ):
            return items.count
        case .UserItems( let items ):
            return items.count
        case .MediaItems( let items):
            return 1    // we're only going to show one image even if there are >1
        case .HashtagItems( let items ):
            return items.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let isImageCell: Bool = hasImage && indexPath.section == 0 && indexPath.row == 0 // image cell if true, else text cell
        switch isImageCell {
        case true:
            let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.ImageCellIdentifier, forIndexPath: indexPath) as! ImageMentionCell
            switch mentions[indexPath.section] {
            case .MediaItems(let items):
                let image = items[0]
                imageURL = image.url    // for ImageVC
                aspectRatio = CGFloat(image.aspectRatio)
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                let queue = dispatch_get_global_queue(qos, 0)
                dispatch_async(queue, {
                    if let imageData = NSData(contentsOfURL: self.imageURL!) {
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.imageV.image = UIImage(data: imageData)
                        })
                    }
                })
                return cell as UITableViewCell
            default:
//                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dummyImageCell")
                break
            }
            
        case false:
            let cell = tableView.dequeueReusableCellWithIdentifier(MentionsConstants.TextCellIdentifier, forIndexPath: indexPath) as! TextMentionCell
            switch mentions[indexPath.section] {
                
            case .UserItems(let items):
                cell.mentionText.text = items[indexPath.row]
                
            case .HashtagItems(let items):
                cell.mentionText.text = items[indexPath.row]
                
            case .UrlItems(let items):
                cell.mentionText.text = items[indexPath.row]
                
            default:
//                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dummyTextCell")
                break
            }
            return cell as UITableViewCell
            
        default:
//            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dummy")
            break
        }
        return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dummy")

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
}
