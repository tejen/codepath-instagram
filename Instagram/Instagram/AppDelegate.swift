//
//  AppDelegate.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/5/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var currentTabIndex = 0;
    var lastTabIndex = 0;
    
    let navigationBarBackgroundColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 135/255.0, alpha: 1);
    
    var newPostImage: UIImage? {
        didSet {
            let tabBarController = self.window?.rootViewController as! TabBarController;
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewControllerWithIdentifier("NewPostViewController") as! UINavigationController;
            let npVc = vc.viewControllers.first as! NewPostViewController;
            npVc.newPostImage = newPostImage;
            tabBarController.presentViewController(vc, animated: true, completion: nil);
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Post.registerSubclass();
        User.registerSubclass();
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Instagram"
                configuration.clientKey = "fnjiweor2389u4ty7ghrjakdpwoqwueihyt4wge"
                configuration.server = "https://pacific-ridge-96383.herokuapp.com/parse"
            })
        );
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true);
        UINavigationBar.appearance().tintColor = UIColor.whiteColor();
                
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}