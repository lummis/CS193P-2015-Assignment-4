//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/8/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
            
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        println()
        println("updateUI()")
        println("user: \(tweet!.user)")
        // reset any previous tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        if tweetProfileImageView != nil {
            if let tpiv = tweetProfileImageView as? UIImageView {
                tpiv.image = nil
            }
        }
        tweetCreatedLabel?.text = nil
        
        // load new information from a tweet (if any)
        if let tweet = self.tweet {
            
            // demo
            let tags = tweet.hashtags
            for tag in tags {
                println("tag.keyword: \(tag.keyword)")
            }
            //

            let attributedText = NSMutableAttributedString(string: tweet.text)

            println("\(tweet.hashtags.count) hashtags")
            for r in tweet.hashtags {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: r.nsrange)
            }
            
            println("\(tweet.urls.count) urls")
            for r in tweet.urls {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: r.nsrange)
            }
            
            println("\(tweet.userMentions.count) userMentions")
            for r in tweet.userMentions {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleColor(), range: r.nsrange)
            }
            // the following doesn't seem to show any mediaMentions. Maybe there are none? And the assignment doesn't call for this.
//            for r in tweet.mediaMentions {
//                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: r.nsrange)
//            }

            println(attributedText)
            
            tweetTextLabel?.attributedText = attributedText
            
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"    // tweet user description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread
                    if let imageV = tweetProfileImageView as? UIImageView { // why as? instead of as
                        imageV.image = UIImage(data: imageData)
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
}
