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
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor(red: 28/255.0, green: 29/255.0, blue: 23/255.0, alpha: 1);
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor(red: 23/255.0, green: 24/255.0, blue: 26/255.0, alpha: 1), size: CGSizeMake(tabBar.frame.width/5, tabBar.frame.height))
        
        // Uses the original colors for your images, so they aren't not rendered as grey automatically.

        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        // Add background color to middle tabBarItem
        let itemIndex = 2;
        let bgColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 135/255.0, alpha: 1.0);
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count);
        let bgView = UIView(frame: CGRectMake(itemWidth * CGFloat(itemIndex), 0, itemWidth, tabBar.frame.height));
        bgView.backgroundColor = bgColor;
        tabBar.insertSubview(bgView, atIndex: 0);

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        if(User.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: self);
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        childViewControllers.map { (vc: UIViewController) in
            (vc as! UINavigationController).navigationBar.barTintColor = appDelegate.navigationBarBackgroundColor;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        if(tabBarController.selectedIndex != 2) { // if not Create Post tab
            appDelegate.lastTabIndex = appDelegate.currentTabIndex;
            appDelegate.currentTabIndex = tabBarController.selectedIndex;
        }
    }
    
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    
        // This is a bit dangerous if we move where 'newController' is located in the tabs, this will break.
//        let newController = viewControllers![2] as! UIViewController;
        
        // Check if the view about to load is the second tab and if it is, load the modal form instead.
//        if viewController == newController {
//            let storyboard = UIStoryboard(name: "ModalController", bundle: nil);
//            let vc = storyboard.instantiateInitialViewController() as? UIViewController;
//            
//            presentViewController(vc!, animated: true, completion: nil);
//            
//            return false;
//        } else {
//            return true;
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}