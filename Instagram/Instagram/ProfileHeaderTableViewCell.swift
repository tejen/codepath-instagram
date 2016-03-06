//
//  ProfileHeaderTableViewCell.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var postsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    
    var user: PFUser! {
        didSet {
            profileNameLabel.text = user.username;
            followersCountLabel.text = (user.objectForKey("followersCount") as? String) ?? "0";
            followingCountLabel.text = (user.objectForKey("followingCount") as? String) ?? "0";
            
            // profileImageView
            
            // postsCountLabel
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
