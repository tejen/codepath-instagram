//
//  CommentsTableViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/12/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class CommentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var parentCell: PostCell!;
    
    var post: Post?;
    var comments: [PFObject]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 160.0;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        reloadComments();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments == nil ? 1 : comments!.count + 1);
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(comments == nil || comments!.count - 1 < indexPath.row) {
            return false;
        }
        
        if((comments![indexPath.row]["user"] as! User).objectId == User.currentUser()!.objectId) {
            return true;
        }
        return false;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let obId = comments![indexPath.row].objectId;
            let comment = PFObject(withoutDataWithClassName: "Comment", objectId: obId);
            Post.postCache[post!.objectId!] = nil;
            comment.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                self.comments?.removeAtIndex(indexPath.row);
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
                print("deleting...");
                self.parentCell.tableViewController1?.posts = nil;
                self.parentCell.tableViewController1?.reloadTable();
            });
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row >= comments?.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewCommentCell") as! CommentEditorTableViewCell;
            cell.post = post;
            cell.commentTableViewController = self;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell;
            cell.comment = comments![indexPath.row];
            cell.commentsTableController = self;
            return cell;
        }
    }
    
    func reloadComments(refreshSuperviewTable: Bool = false) {
        post = Post.cache(post!.objectId!);
        comments = post?.getCachedComments({ (comments: [PFObject]?) -> () in
            self.comments = comments;
            self.tableView.reloadData();
        });
        
        tableView.reloadData();
        
        if(refreshSuperviewTable) {
            parentCell.tableViewController1?.posts = nil;
//            Post.postCache = [:];
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
