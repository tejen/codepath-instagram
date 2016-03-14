//
//  ProfileTableViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ProfileTableViewController: UITableViewController {

    @IBOutlet var profileTableView: UITableView!
    @IBOutlet weak var cogBarButton: UIBarButtonItem!
    
    var user: User?;
    var posts: [Post]?;
    
    var detailPost: Post?;
    
    var modal = false;
    
    var readyForTableLayout = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if(user == nil) {
            user = User.currentUser();
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        navigationController?.navigationBar.barTintColor = appDelegate.navigationBarBackgroundColor;
        
        profileTableView.delegate = self;
        profileTableView.dataSource = self;
        
        profileTableView.rowHeight = UITableViewAutomaticDimension;
        profileTableView.estimatedRowHeight = 160.0;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        readyForTableLayout = true;
        
        user!.posts(completion: { (posts: [PFObject]?, error: NSError?) -> Void in
            self.posts = posts as? [Post];
            self.tableView.reloadData();
        });
        
        if(modal) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("dismissModal"));
        }
    }
    
    func dismissModal() {
        dismissViewControllerAnimated(true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(readyForTableLayout) {
            let cellCount = Int(1.0 + ceil(Double(posts?.count ?? 0) / 3.0));
            return cellCount;
        }
        
        return 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ProfileHeaderTableViewCell;
            cell.user = user;
            cell.profileTableViewController = self;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CollectionRowCell") as! ProfileCollectionRowTableViewCell;
            
            cell.profileTableController = self;
            
            var leftmostIndex = 3 * (indexPath.row - 1);
            
            cell.postOne = posts?[leftmostIndex++];
            
            if(leftmostIndex >= posts?.count) {
                cell.postTwo = nil;
                cell.postThree = nil;
                return cell;
            }
            
            cell.postTwo = posts?[leftmostIndex++];
            
            if(leftmostIndex >= posts?.count) {
                cell.postThree = nil;
                return cell;
            }
            
            cell.postThree = posts?[leftmostIndex++];
            return cell;
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetails") {
            let dVc = segue.destinationViewController as! DetailsViewController;
            dVc.post = detailPost;
        }
    }

}
