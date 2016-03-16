//
//  DetailsViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/10/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]?;
    
    var inspectPostComments: Post?;
    
    var refreshControl: UIRefreshControl!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 160.0;
        
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged);
        tableView.insertSubview(refreshControl, atIndex: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell;
        cell.post = posts![indexPath.row];
        cell.tableViewController2 = self;
        cell.indexPathSection = indexPath.row;
        return cell;
    }
    
    func onRefresh() {
        reloadTable();
        delay(2, closure: {
            self.refreshControl.endRefreshing();
        })
    }
    
    func reloadTable(append: Bool = false) {
        if(posts != nil) {
            posts![0] = Post.cache(posts![0].objectId!)!;
        }
        tableView.reloadData();
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toComments") {
            let vc = segue.destinationViewController as! CommentsTableViewController;
            vc.post = inspectPostComments;
            vc.parentCell = sender as! PostCell;
        }
    }
}
