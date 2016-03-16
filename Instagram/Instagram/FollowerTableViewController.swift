//
//  FollowerTableViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/15/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class FollowerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Relationship {
        case Followers
        case Following
        case Likers
    }
    
    var inspect: Relationship?;
    
    var relationships: [PFObject]?;
    
    var user: User?;
    var post: Post?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        reloadTable();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        var query: PFQuery?;
        if(inspect == .Followers) {
            query = PFQuery(className: "Follows");
            query!.whereKey("followed", equalTo: user!);
            query!.selectKeys(["follower"]);
            query!.includeKey("follower");
        }
        if(inspect == .Following) {
            query = PFQuery(className: "Follows");
            query!.whereKey("follower", equalTo: user!);
            query!.selectKeys(["followed"]);
            query!.includeKey("followed");
        }
        if(inspect == .Likers) {
            query = PFQuery(className: "Like");
            query!.whereKey("post", equalTo: post!);
            query!.selectKeys(["user"]);
            query!.includeKey("user");
        }
        do{
            try relationships = query!.findObjects();
        } catch(_) {
            
        }
        tableView.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relationships?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RelationshipCell") as! RelationshipCell;
        cell.parentViewController = self;
        
        cell.localUser = user;
        if(inspect == .Following) {
            cell.remoteUser = relationships![indexPath.row]["followed"] as? User;
        }
        if(inspect == .Followers) {
            cell.remoteUser = relationships![indexPath.row]["follower"] as? User;
        }
        if(inspect == .Likers) {
            cell.remoteUser = relationships![indexPath.row]["user"] as? User;
        }
        
        return cell;
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
