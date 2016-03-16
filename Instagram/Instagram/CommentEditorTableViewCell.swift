//
//  CommentEditorTableViewCell.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/12/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class CommentEditorTableViewCell: UITableViewCell {
    
    weak var commentTableViewController: CommentsTableViewController?;
    
    var post: Post?;

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButtonSuperview: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sendButtonSuperview.layer.cornerRadius = 5;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editingDidChange(sender: AnyObject) {
        if(commentField.text?.characters.count > 0) {
            sendButton.alpha = 1;
        } else {
            sendButton.alpha = 0.5;
        }
    }
    
    @IBAction func onSendButton(sender: AnyObject) {
        commentField.resignFirstResponder();
        let commentText = commentField.text!;
        if(commentField.text!.characters.count > 0){
            sendButton.hidden = true;
            activityIndicator.startAnimating();
            commentField.userInteractionEnabled = false;
            commentField.textColor = UIColor.lightGrayColor();
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.activityIndicator.alpha = 1;
            });
            post!.comment(commentText) { (success: Bool, error: NSError?) -> Void in
                Post.postCache[self.post!.objectId!] = nil;
                self.commentTableViewController!.reloadComments(true);
                delay(0.5, closure: { () -> () in
                    self.activityIndicator.stopAnimating();
                    self.sendButton.hidden = false;
                    self.commentField.text = "";
                    self.commentField.userInteractionEnabled = true;
                    self.commentField.textColor = UIColor.blackColor();
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.activityIndicator.alpha = 0;
                    });
                });
            }
        }
    }
}
