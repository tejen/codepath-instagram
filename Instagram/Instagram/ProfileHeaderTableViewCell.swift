//
//  ProfileHeaderTableViewCell.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var postsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    
    @IBOutlet var dividerShadow: UIView!
    
    @IBOutlet var editButton: UIButton!
    
    weak var profileTableViewController: ProfileTableViewController!;
    
    var user: User! {
        didSet {
            profileNameLabel.text = "@\(user.username!)";
            followersCountLabel.text = String(user.followersCount!);
            followingCountLabel.text = String(user.followingCount!);

            profileImageView.clipsToBounds = true;
            delay(1.0) { () -> () in
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
            }

            // getDataInBackgroundWithBlock inhibits https/SSL. Using this hack instead...
            profileImageView.setImageWithURL(user.profilePicURL!);

            postsCountLabel.text = String(user.postsCount!);
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editButton.backgroundColor = UIColor(white: 0.93, alpha: 1.0);
        editButton.layer.cornerRadius = 5;
        
        let gradientLayer = CAGradientLayer();
        gradientLayer.frame = dividerShadow.bounds;
        let topColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor as CGColorRef;
        let bottomColor = UIColor(white: 0, alpha: 0.0).CGColor as CGColorRef;
        gradientLayer.colors = [topColor, bottomColor];
        gradientLayer.locations = [0.0, 1.0];
        self.dividerShadow.layer.addSublayer(gradientLayer);
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("onTappedProfilePic"));
        profileImageView.userInteractionEnabled = true;
        profileImageView.addGestureRecognizer(tap);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTappedProfilePic() {
        if(user.username == User.currentUser()?.username) {
            profileTableViewController.performSegueWithIdentifier("toProfilePicEditor", sender: profileTableViewController);
        }
    }

}
