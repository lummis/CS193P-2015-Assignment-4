//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/7/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var tweets = [[Tweet]]()
    var searchText: String? = "#unionSquare" {   // default search is #unionSquare
        didSet {
            searchTextField?.text = searchText  // just in case somebody updates public searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh() {
        if searchText != nil {
            let request = TwitterRequest(search: searchText!, count: 100)
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText   // in case someone set it before
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {   // there's no other possibility, but just for safety
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
