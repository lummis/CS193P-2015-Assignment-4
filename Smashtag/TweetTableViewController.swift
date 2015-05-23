//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/7/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//
//  follows Stanford CS193P online course

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    let debugPrinting = false
    
    private struct TweetsConstants {
        static let CellReuseIdentifier = "tweet"
        static let TweetsMentionsSegueName: String = "tweets-mentions"
    }

    var tweets = [[Tweet]]()
    
    var searchText: String? = "#audi" {   // initial search text
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText  // just in case somebody updates public searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    enum MentionedItems {
        case UserItems      ( [String] )
        case UrlItems       ( [String] )
        case HashtagItems   ( [String] )
        case MediaItems     ( [MediaItem] )       // media
    }
    
    var mentions: [MentionedItems]!
    
    // MARK: - ViewController delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Class
    func refresh() {
//        if refreshControl != nil {
//            refreshControl?.beginRefreshing()
//        }
        refreshControl?.beginRefreshing()
        refreshAction(refreshControl)
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 50)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }

    @IBAction private func refreshAction(sender: UIRefreshControl?) {
        println("refreshAction")
        
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        self.refreshControl?.endRefreshing()
                    }
                }
            } else {
           sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText   // in case someone set it before
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let cell = sender as! TweetTableViewCell
        let tweet = cell.tweet
        
        var destinationVC = segue.destinationViewController as! MentionsTVC
        destinationVC.title = tweet?.user.screenName
        
        populateMentions(tweet!)
        destinationVC.aspectRatio = self.aspectRatio
        println("self.aspectRatio: \(self.aspectRatio)")
        destinationVC.mentions = self.mentions
    }
    
    private var aspectRatio: CGFloat = 1
    
    private func populateMentions(tweet: Tweet) {
        mentions = []   // get rid of old content if any
        
        var medias = [MediaItem]()
        for item in tweet.media {
            medias.append(item)
        }
        if medias.count > 0 {
            mentions.append( MentionedItems.MediaItems( medias ))
            aspectRatio = CGFloat(medias[0].aspectRatio) // LAME! - only show the first image
        }
        
        var screenNames: [String] = []
        for user in tweet.userMentions { screenNames.append(user.keyword) }
        if screenNames.count > 0 { mentions.append( MentionedItems.UserItems( screenNames )) }
        
        var hashtags: [String] = []
        for tag in tweet.hashtags { hashtags.append(tag.keyword) }
        if hashtags.count > 0 { mentions.append( MentionedItems.HashtagItems( hashtags )) }
        
        var urls: [String] = []
        for url in tweet.urls { urls.append(url.keyword) }
        if urls.count > 0 { mentions.append( MentionedItems.UrlItems( urls )) }

    }
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {   // there's no other possibility, but just for safety
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        searchTextField.resignFirstResponder()
        searchText = searchTextField.text
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TweetTableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(TweetsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        if debugPrinting {
            println()
            println("==========")
            println(cell.tweet)
            for item in cell.tweet!.media {
                println("media item: \(item.description)")
            }
            println("==========")
        }
        
        return cell
    }

    @IBAction private func unwindToTweets(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as! MentionsTVC
        searchText = sourceViewController.textForNextSearch
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
