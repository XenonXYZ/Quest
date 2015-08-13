//
//  FriendCell.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/10/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var picView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
