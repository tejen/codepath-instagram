//
//  RelationshipCell.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/15/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class RelationshipCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    weak var parentViewController: UIViewController!;
    
    var localUser: User?;
    var remoteUser: User? {
        didSet {
            usernameLabel.text = remoteUser!.username;
            profilePic.setImageWithURL(remoteUser!.profilePicURL!);
            if(remoteUser!.objectId == User.currentUser()!.objectId){
                followButton.hidden = true;
            } else if(remoteUser!.isFollowed) {
                followButtonSetStyleComplete();
            } else {
                followButtonSetStyleActionable();
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.clipsToBounds = true;
        profilePic.layer.cornerRadius = 15;
        
        followButton.layer.cornerRadius = 5;
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("openRemoteUser"));
        profilePic.userInteractionEnabled = true;
        profilePic.addGestureRecognizer(tap);
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("openRemoteUser"));
        usernameLabel.userInteractionEnabled = true;
        usernameLabel.addGestureRecognizer(tap);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func followButtonSetStyleActionable(){
        followButton.setTitle("Follow", forState: .Normal);
        followButton.backgroundColor = UIColor.clearColor();
        followButton.setTitleColor(InstagramActionableColor, forState: .Normal);
        followButton.layer.borderColor = InstagramActionableColor.CGColor;
        followButton.layer.borderWidth = 1;
    }
    
    func followButtonSetStyleComplete(){
        followButton.setTitle("Following", forState: .Normal);
        followButton.backgroundColor = InstagramGreenColor;
        followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        followButton.layer.borderWidth = 0;
    }
    
    func openRemoteUser() {
        let pVc = storyboard.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController;
        pVc.user = remoteUser!;
        parentViewController.navigationController?.pushViewController(pVc, animated: true);
    }
    
    @IBAction func onFollowButton(sender: UIButton) {
        if(remoteUser!.isFollowed != true) {
            remoteUser!.follow(true);
            followButtonSetStyleComplete();
        } else {
            remoteUser!.follow(false);
            followButtonSetStyleActionable();
        }
    }
}
