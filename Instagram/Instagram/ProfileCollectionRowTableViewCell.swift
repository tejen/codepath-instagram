//
//  ProfileCollectionRowTableViewCell.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class ProfileCollectionRowTableViewCell: UITableViewCell {
    
    weak var profileTableController: ProfileTableViewController?;
    
    @IBOutlet weak var activityOne: UIActivityIndicatorView!
    @IBOutlet weak var activityTwo: UIActivityIndicatorView!
    @IBOutlet weak var activityThree: UIActivityIndicatorView!
    
    var postOne: Post? {
        didSet {
            if(postOne != nil) {
                activityOne.startAnimating();
                imageOne.setImageWithURLRequest(NSURLRequest(URL: postOne!.mediaURL!), placeholderImage: nil, success: { (req: NSURLRequest, res: NSHTTPURLResponse?, img: UIImage) -> Void in
                    self.activityOne.stopAnimating();
                    self.imageOne.image = img;
                    }, failure: nil);
            } else {
                activityOne.stopAnimating();
            }
        }
    }
    var postTwo: Post? {
        didSet {
            if(postTwo != nil) {
                activityTwo.startAnimating();
                imageTwo.setImageWithURLRequest(NSURLRequest(URL: postTwo!.mediaURL!), placeholderImage: nil, success: { (req: NSURLRequest, res: NSHTTPURLResponse?, img: UIImage) -> Void in
                    self.activityTwo.stopAnimating();
                    self.imageTwo.image = img;
                    }, failure: nil);
                
            } else {
                activityTwo.stopAnimating();
                imageTwo.hidden = true;
            }
        }
    }
    var postThree: Post? {
        didSet {
            if(postThree != nil) {
                activityThree.startAnimating();
                imageThree.setImageWithURLRequest(NSURLRequest(URL: postThree!.mediaURL!), placeholderImage: nil, success: { (req: NSURLRequest, res: NSHTTPURLResponse?, img: UIImage) -> Void in
                    self.activityThree.stopAnimating();
                    self.imageThree.image = img;
                    }, failure: nil);
            } else {
                activityThree.stopAnimating();
                imageThree.hidden = true;
            }
        }
    }

    @IBOutlet var imageOne: UIImageView!;
    @IBOutlet var imageTwo: UIImageView!;
    @IBOutlet var imageThree: UIImageView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        var taps = [
            UITapGestureRecognizer(target: self, action: Selector("onTappedLeftPhoto")),
            UITapGestureRecognizer(target: self, action: Selector("onTappedCenterPhoto")),
            UITapGestureRecognizer(target: self, action: Selector("onTappedRightPhoto")),
        ];
        
        [imageOne, imageTwo, imageThree].map { imageView in
            taps[0].delegate = self;
            imageView.addGestureRecognizer(taps[0]);
            taps.removeAtIndex(0);
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTappedLeftPhoto() {
        profileTableController?.detailPost = postOne;
        
        UIView.animateWithDuration(0.05) { () -> Void in
            self.imageOne.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.imageOne.alpha = 1;
            }
            self.profileTableController?.performSegueWithIdentifier("toDetails", sender: self.profileTableController);
        }
    }
    
    func onTappedCenterPhoto() {
        profileTableController?.detailPost = postTwo;

        UIView.animateWithDuration(0.05) { () -> Void in
            self.imageTwo.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.imageTwo.alpha = 1;
            }
            self.profileTableController?.performSegueWithIdentifier("toDetails", sender: self.profileTableController);
        }
    }
    
    func onTappedRightPhoto() {
        profileTableController?.detailPost = postThree;

        UIView.animateWithDuration(0.05) { () -> Void in
            self.imageThree.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.imageThree.alpha = 1;
            }
            self.profileTableController?.performSegueWithIdentifier("toDetails", sender: self.profileTableController);
        }
    }

}
