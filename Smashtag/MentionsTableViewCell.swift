//
//  MentionsTableViewCell.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/12/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class MentionsTableViewCell: UITableViewCell {

    @IBOutlet weak var mentionLabel1: UILabel! {
        didSet {
            println("MentionsTableViewCell; didSet mentionLabel1")
        }
    }
    
    func updateUI() {
        println("MentionsTableViewCell; updateUI()")
    }
}
