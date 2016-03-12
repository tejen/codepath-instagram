//
//  NewPostTabViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/9/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class NewPostTabViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func revertSelectedIndex() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let tVc = tabBarController as! TabBarController;
        let newTabIndex = (appDelegate.currentTabIndex == 2 ? appDelegate.lastTabIndex : appDelegate.currentTabIndex)
        tVc.selectedIndex = newTabIndex;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        revertSelectedIndex();
        delay(0.1) { () -> () in
            self.revertSelectedIndex();
        }
        
        //        if(UIImagePickerController.isCameraDeviceAvailable(.Rear) != true) {
        //            appDelegate.selectedPhotoSource = .PhotoLibrary;
        //        } else {
        //            // action sheet to select from camera/library
        //        }
        
        //        for iOS simulator and demo purposes, show the Camera/Library picker regardless of device camera availability
        
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet);
        
        let takePhoto: UIAlertAction = UIAlertAction(title: "Take a Photo", style: .Default)
            { action -> Void in
                let vc = UIImagePickerController();
                vc.delegate = self;
                vc.allowsEditing = true;
                vc.sourceType = UIImagePickerControllerSourceType.Camera;
                
                self.presentViewController(vc, animated: true, completion: nil);
        }
        actionSheet.addAction(takePhoto)
        
        let fromLibrary: UIAlertAction = UIAlertAction(title: "Choose Existing", style: .Default) { action -> Void in
            let vc = UIImagePickerController();
            vc.delegate = self;
            vc.allowsEditing = true;
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            self.presentViewController(vc, animated: true, completion: nil);
        }
        actionSheet.addAction(fromLibrary)
        
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { action -> Void in
                self.dismissViewControllerAnimated(true, completion: nil);
        }
        actionSheet.addAction(cancelButton)
        
        self.presentViewController(actionSheet, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil);
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.newPostImage = info[UIImagePickerControllerEditedImage] as! UIImage;
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
