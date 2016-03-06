//
//  TabBarController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.alpha = 0;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        if(PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: self);
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.alpha = 1;
            });
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToSignIn() {
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.view.alpha = 0;
            }) { (complete: Bool) -> Void in
                self.performSegueWithIdentifier("toLogin", sender: self);
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
