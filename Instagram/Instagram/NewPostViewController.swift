//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/9/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addLocationSuperview: UIView!
    
    @IBOutlet weak var facebookSuperview: UIView!
    @IBOutlet weak var twitterSuperview: UIView!
    @IBOutlet weak var tumblrSuperview: UIView!
    @IBOutlet weak var flickrSuperview: UIView!
    
    @IBOutlet weak var shareActionView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var newPostImage: UIImage?;
    
    var textViewPlaceholder: String?;
    
    var submitting = false;
    
    var newPost: Post?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        [captionView, addLocationSuperview, facebookSuperview, twitterSuperview, tumblrSuperview, flickrSuperview].map { view in
            view.layer.borderColor = UIColor(white: 0.75, alpha: 1).CGColor;
            view.layer.borderWidth = 1;
        }
        
        imageView.image = newPostImage;
        imageView.userInteractionEnabled = true;
        imageView.layer.cornerRadius = 5;
        
        textViewPlaceholder = textView.text;
        textView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        if(submitting != true) {
            dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == textViewPlaceholder) {
            textView.text = "";
            textView.textColor = UIColor.blackColor();
        }
        textView.becomeFirstResponder();
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "") {
            textView.text = textViewPlaceholder;
            textView.textColor = UIColor(white: 2/3, alpha: 1);
        }
        textView.resignFirstResponder();
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder();
            return false;
        }
        return true;
    }
    
    @IBAction func onTapImage(sender: AnyObject) {
        performSegueWithIdentifier("toPreview", sender: self);
    }

    @IBAction func onShareButton(sender: AnyObject) {
        submitting = true;
        
        activityIndicatorView.hidden = false;
        
        UIView.animateWithDuration(1.0) { () -> Void in
            self.activityIndicatorView.alpha = 1;
        }
        
        var captionText = textView.text;
        if(captionText == textViewPlaceholder) {
            captionText = "";
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        newPost = Post(image: newPostImage, withCaption: captionText) { (success: Bool, error: NSError?) -> Void in
            
            let captionText = self.textView.text;
            if(captionText != self.textViewPlaceholder) {
                self.newPost?.comment(captionText);
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
            let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
            tabBarController.selectedIndex = 0;
            let nVc = tabBarController.viewControllers?.first as! UINavigationController;
            let hVc = nVc.viewControllers.first as! HomeViewController;
            hVc.reloadTable();
            self.dismissViewControllerAnimated(true, completion: nil);
        };
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toPreview") {
            let vc = segue.destinationViewController as! UINavigationController;
            let pVc = vc.viewControllers.first as! PreviewViewController;
            pVc.image = newPostImage;
        }
    }

}
