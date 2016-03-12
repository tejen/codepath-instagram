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
    
    var post: Post?;
    var comments: [PFObject]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
        
        reloadComments();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments == nil ? 1 : comments!.count + 1);
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
    
    func reloadComments() {
        comments = post?.comments;
        tableView.reloadData();
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
