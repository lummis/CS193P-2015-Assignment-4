//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/8/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetTimeL: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {

        // reset any previous tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        if tweetProfileImageView != nil {
            if let tpiv = tweetProfileImageView as? UIImageView {
                tpiv.image = nil
            }
        }
        tweetTimeL?.text = nil
        
        // load new information from a tweet (if any)
        if let tweet = self.tweet {

            var cameraString = ""
            for _ in tweet.media { cameraString += " 📷" }
            let attributedText = NSMutableAttributedString(string: tweet.text + cameraString)

            for r in tweet.hashtags {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: r.nsrange)
            }
            
            for r in tweet.urls {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: r.nsrange)
            }
            
            for r in tweet.userMentions {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: r.nsrange)
            }
            
            tweetTextLabel?.attributedText = attributedText
            tweetScreenNameLabel?.text = "\(tweet.user)"    // tweet user description
            
            if let profileImageURL = tweet.user.profileImageURL {
                let currentProfileImageURL = profileImageURL
                let qos = Int(QOS_CLASS_USER_INITIATED.value)   // 2nd highest of 4
                let queue = dispatch_get_global_queue(qos, 0)
                dispatch_async(queue) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            if profileImageURL == currentProfileImageURL {
                                if let imageV = self.tweetProfileImageView as? UIImageView { // needs main queue
                                    imageV.image = UIImage(data: imageData)
                                }
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetTimeL?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
}
