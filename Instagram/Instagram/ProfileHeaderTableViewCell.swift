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
    @IBOutlet weak var followersTitleLabel: UILabel!
    @IBOutlet weak var followingTitleLabel: UILabel!
    
    @IBOutlet var dividerShadow: UIView!
    
    @IBOutlet var editButton: UIButton!
    
    weak var profileTableViewController: ProfileTableViewController!;
    
    var user: User! {
        didSet {
            profileNameLabel.text = "@\(user.username!)";
            followersCountLabel.text = String(user.followersCount!);
            followingCountLabel.text = String(user.followingCount!);
            
            let tapFollowers = UITapGestureRecognizer(target: self, action: Selector("inspectFollowers"));
            followersCountLabel.userInteractionEnabled = true;
            followersCountLabel.addGestureRecognizer(tapFollowers);
            let tapFollowers2 = UITapGestureRecognizer(target: self, action: Selector("inspectFollowers"));
            followersTitleLabel.userInteractionEnabled = true;
            followersTitleLabel.addGestureRecognizer(tapFollowers2);
            
            let tapFollowing = UITapGestureRecognizer(target: self, action: Selector("inspectFollowing"));
            followingCountLabel.userInteractionEnabled = true;
            followingCountLabel.addGestureRecognizer(tapFollowing);
            let tapFollowing2 = UITapGestureRecognizer(target: self, action: Selector("inspectFollowing"));
            followingTitleLabel.userInteractionEnabled = true;
            followingTitleLabel.addGestureRecognizer(tapFollowing2);

            if(profileImageView.image == nil) {
                profileImageView.clipsToBounds = true;
                profileImageView.alpha = 0;
                delay(1.0) { () -> () in
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.profileImageView.alpha = 1;
                    });
                }
                
                // getDataInBackgroundWithBlock inhibits https/SSL. Using this hack instead...
                profileImageView.setImageWithURL(user.profilePicURL!);
            }

            postsCountLabel.text = String(user.postsCount!);
            
            if(user.objectId == User.currentUser()?.objectId) {
                editButtonSetStyleNeutral();
            } else {
                let tap = UITapGestureRecognizer(target: self, action: Selector("onFollowButton"));
                editButton.userInteractionEnabled = true;
                editButton.addGestureRecognizer(tap);
                
                if(user.isFollowed){
                    editButtonSetStyleComplete();
                } else {
                    editButtonSetStyleActionable();
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
            profileTableViewController.performSegueWithIdentifier("toProfilePicEditor", sender: self);
        }
    }
    
    func onFollowButton() {
        if(user.isFollowed != true) {
            user.follow(true);
            editButtonSetStyleComplete();
        } else {
            user.follow(false);
            editButtonSetStyleActionable();
        }
        followersCountLabel.text = String(user.followersCount!);
    }
    
    func inspectFollowers() {
        
        UIView.animateWithDuration(0.05) { () -> Void in
            self.followersCountLabel.alpha = 0.25;
            self.followersTitleLabel.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.followersCountLabel.alpha = 1;
                self.followersTitleLabel.alpha = 1;
            }
            self.profileTableViewController.performSegueWithIdentifier("toFollowers", sender: self);
        }
    }
    
    func inspectFollowing() {
        UIView.animateWithDuration(0.05) { () -> Void in
            self.followingCountLabel.alpha = 0.25;
            self.followingTitleLabel.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.followingCountLabel.alpha = 1;
                self.followingTitleLabel.alpha = 1;
            }
            self.profileTableViewController.performSegueWithIdentifier("toFollowing", sender: self);
        }
    }
    
    func editButtonSetStyleNeutral(){
        editButton.setTitle("Edit Profile", forState: .Normal);
        editButton.backgroundColor = InstagramNeutralColor;
        editButton.setTitleColor(UIColor.blackColor(), forState: .Normal);
        editButton.layer.borderWidth = 0;
    }
    
    func editButtonSetStyleActionable(){
        editButton.setTitle("Follow", forState: .Normal);
        editButton.backgroundColor = UIColor.clearColor();
        editButton.setTitleColor(InstagramActionableColor, forState: .Normal);
        editButton.layer.borderColor = InstagramActionableColor.CGColor;
        editButton.layer.borderWidth = 1;
    }
    
    func editButtonSetStyleComplete(){
        editButton.setTitle("Following", forState: .Normal);
        editButton.backgroundColor = InstagramGreenColor;
        editButton.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        editButton.layer.borderWidth = 0;
    }

}
