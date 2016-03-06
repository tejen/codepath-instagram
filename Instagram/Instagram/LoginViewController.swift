//
//  LoginViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/5/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var usernameFieldBackgroundView: UIView!
    @IBOutlet var passwordFieldBackgroundView: UIView!
    @IBOutlet var loginButtonSuperview: UIView!
    @IBOutlet var signupButtonSuperview: UIView!
    @IBOutlet var loginButton: UIButton!
    
    var canSubmit = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
        
        usernameFieldBackgroundView.layer.cornerRadius = 5.0;
        passwordFieldBackgroundView.layer.cornerRadius = 5.0;
        loginButtonSuperview.layer.cornerRadius = 5.0;
        loginButtonSuperview.layer.borderWidth = 2;
        loginButtonSuperview.layer.borderColor = UIColor(white: 1, alpha: 0.15).CGColor;
        
        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged);
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        tabBarController.view.alpha = 1.0;
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.logoImageView.alpha = 1;
            self.usernameFieldBackgroundView.alpha = 1;
            self.passwordFieldBackgroundView.alpha = 1;
            self.loginButtonSuperview.alpha = 1;
            self.signupButtonSuperview.alpha = 1;
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        if(canSubmit != true) {
            return;
        }
        disableSubmit();
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            self.enableSubmit();
            if(error != nil) {
                print(error?.localizedDescription);
                let alertController = UIAlertController(title: "Login Failed", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil));
                self.presentViewController(alertController, animated: true, completion: nil);
            } else {
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        // slide up and fade out elements
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.logoImageView.alpha = 0;
                self.usernameFieldBackgroundView.alpha = 0;
                self.passwordFieldBackgroundView.alpha = 0;
                self.loginButtonSuperview.alpha = 0;
                self.signupButtonSuperview.alpha = 0;
            }) { (success: Bool) -> Void in
                self.performSegueWithIdentifier("toSignup", sender: self);
        }
    }

    func enableSubmit() {
        canSubmit = true;
        loginButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal);
        loginButton.userInteractionEnabled = true;
    }

    func disableSubmit() {
        canSubmit = false;
        loginButton.setTitleColor(UIColor(white: 1, alpha: 0.4), forState: .Normal);
        loginButton.userInteractionEnabled = false;
    }
    
    func textFieldDidChange() {
        if(usernameField.text?.characters.count > 0) {
            if(passwordField.text?.characters.count > 0) {
                enableSubmit();
                return;
            }
        }
        disableSubmit();
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
