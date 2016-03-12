//
//  SettingsTableViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var cellPrivateAccount: UITableViewCell!
    @IBOutlet weak var cellSaveOriginals: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ([cellPrivateAccount, cellSaveOriginals]).map { cell in
            cell.accessoryView = UISwitch();
        } // super cool !!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut() {
        
        var refreshAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out of Instagram?", preferredStyle: UIAlertControllerStyle.Alert);
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil));
        
        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (action: UIAlertAction!) in
            User.logOutInBackground();
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
            let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
            tabBarController.performSegueWithIdentifier("toLogin", sender: self);
            delay(2.0, closure: { () -> () in
                tabBarController.selectedIndex = 0;
            })
        }));
        
        presentViewController(refreshAlert, animated: true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "LogOutCell") {
            logOut();
        }
    }
}
