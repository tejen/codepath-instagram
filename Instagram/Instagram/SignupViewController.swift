//
//  LoginViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/5/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var canSubmit = false;
    var didSetProfilePic = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        usernameField.delegate = self;
        passwordField.delegate = self;
        
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
        
        profilePicImageView.clipsToBounds = true;
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.width/2;
        
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
        let newUser = User();
        
        newUser.username = usernameField.text;
        newUser.password = passwordField.text;
        
        if(didSetProfilePic) {
            newUser.setObject(Post.generateFileFromImage(profilePicImageView.image!), forKey: "profilePicture");
        } else {
            newUser.setObject(Post.generateFileFromImage(UIImage(named: "Icon-Profile-Default")!), forKey: "profilePicture");
        }
        
        startSubmitting();
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
            } else {
                self.stopSubmitting();
                let alertController = UIAlertController(title: "Uh oh!", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default,handler: nil));
                self.presentViewController(alertController, animated: true, completion: nil);
            }
        }
    }
    
    func stopSubmitting() {
        enableSubmit();
        activityIndicatorView.alpha = 0;
        activityIndicatorView.stopAnimating();
        signupButton.setTitle("Sign Up", forState: .Normal);
    }
    
    func startSubmitting() {
        disableSubmit();
        signupButton.setTitle("", forState: .Normal);
        activityIndicatorView.startAnimating();
        activityIndicatorView.alpha = 1;
        
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
    
    @IBAction func onProfilePic(sender: AnyObject) {
        let vc = UIImagePickerController();
        vc.delegate = self;
        vc.allowsEditing = true;
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        presentViewController(vc, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
//            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Do something with the images (based on your use case)
            profilePicImageView.contentMode = .ScaleAspectFill;
            profilePicImageView.layer.borderColor = UIColor.whiteColor().CGColor;
            profilePicImageView.layer.borderWidth = 2.0;
            profilePicImageView.image = editedImage;
            
            didSetProfilePic = true;
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true);
        return false;
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
