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
//            tweetTextLabel?.text = tweet.text
            let attributedText = NSMutableAttributedString(string: tweet.text)
            let textRange = NSMakeRange(8, 5)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: textRange)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(16, 5))
            attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(3,7))
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
