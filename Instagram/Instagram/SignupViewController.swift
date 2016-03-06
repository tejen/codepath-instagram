//
//  LoginViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/5/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var usernameFieldBackgroundView: UIView!
    @IBOutlet var passwordFieldBackgroundView: UIView!
    @IBOutlet var signupButtonSuperview: UIView!
    @IBOutlet var signinButtonSuperview: UIView!
    @IBOutlet var termsDisclaimerLabel: UILabel!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var profilePicImageView: UIImageView!
    @IBOutlet var profilePicLabel: UILabel!
    
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
        signupButtonSuperview.layer.cornerRadius = 5.0;
        signupButtonSuperview.layer.borderWidth = 2;
        signupButtonSuperview.layer.borderColor = UIColor(white: 1, alpha: 0.15).CGColor;
        
//        termsDisclaimerLabel.attributedText
        let content = "By signing up, you agree to our ";
        let text = NSMutableAttributedString(string: content);
        text.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0), range: NSRange(location: 0, length: content.characters.count));
        
        let linkText = "Terms & Privacy Policy";
        let link = NSMutableAttributedString(string: linkText);
        link.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0, weight: UIFontWeightSemibold), range: NSRange(location: 0, length: linkText.characters.count));
        
        let punctuation = NSMutableAttributedString(string: ".");
        text.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0), range: NSRange(location: 0, length: 1));
        
        text.appendAttributedString(link);
        text.appendAttributedString(punctuation);
        
        termsDisclaimerLabel.attributedText = text;
        
        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged);
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.usernameFieldBackgroundView.alpha = 1;
            self.passwordFieldBackgroundView.alpha = 1;
            self.signupButtonSuperview.alpha = 1;
            self.signinButtonSuperview.alpha = 1;
            self.termsDisclaimerLabel.alpha = 1;
            self.profilePicImageView.alpha = 1;
            self.profilePicLabel.alpha = 1;
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.usernameFieldBackgroundView.alpha = 0;
            self.passwordFieldBackgroundView.alpha = 0;
            self.signupButtonSuperview.alpha = 0;
            self.signinButtonSuperview.alpha = 0;
            self.termsDisclaimerLabel.alpha = 0;
            self.profilePicImageView.alpha = 0;
            self.profilePicLabel.alpha = 0;
            }) { (success: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser();
        
        newUser.username = usernameField.text;
        newUser.password = passwordField.text;
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("created successfully");
                self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
            } else {
                let alertController = UIAlertController(title: "Login Failed", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil));
                self.presentViewController(alertController, animated: true, completion: nil);
            }
        }
    }
    
    func enableSubmit() {
        canSubmit = true;
        signupButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal);
        signupButton.userInteractionEnabled = true;
    }
    
    func disableSubmit() {
        canSubmit = false;
        signupButton.setTitleColor(UIColor(white: 1, alpha: 0.4), forState: .Normal);
        signupButton.userInteractionEnabled = false;
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
