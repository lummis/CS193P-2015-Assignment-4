//
//  MentionsTVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/12/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

private struct mentionsConstants {
    static let CellReuseIdentifier = "mention"
}

class MentionsTVC: UITableViewController {

    let sectionHeaders = ["Images", "Hashtags", "URLs", "UserScreenNames"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected section \(indexPath.section), row \(indexPath.row)")
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }
    
    // provides the header text if tableView(tableView: UITableView, viewForHeaderInSection section: Int) doesn't override it
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MentionsTableViewCell = tableView.dequeueReusableCellWithIdentifier(mentionsConstants.CellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewCell
        cell.mentionsLabel1.text = "IndexPath.row: \(indexPath.row)"
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
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
