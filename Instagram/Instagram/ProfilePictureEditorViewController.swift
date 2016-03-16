//
//  ProfilePictureEditorViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/12/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

class ProfilePictureEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var profileHeaderTableView: ProfileHeaderTableViewCell!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false);

        // Do any additional setup after loading the view.
        imageView.clipsToBounds = true;
        delay(1.0) { () -> () in
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapImageView(sender: AnyObject) {
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
            imageView.contentMode = .ScaleAspectFill;
            imageView.layer.borderColor = UIColor.whiteColor().CGColor;
            imageView.layer.borderWidth = 2.0;
            imageView.image = editedImage;
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil);
            
            updateProfilePic();
    }
    
    func updateProfilePic() {
        activityIndicator.startAnimating();
        
        let image = Post.generateFileFromImage(imageView.image!);
        profileHeaderTableView.profileImageView!.image = self.imageView.image;
        User.currentUser()!.setObject(image, forKey: "profilePicture");
        
        delay(0.1) { () -> () in
            do{
                try image.save();
                try User.currentUser()?.save();
                User.currentUser()!.profilePicURL = NSURL(string: Post.getURLFromFile(image));
                self.activityIndicator.stopAnimating();
                self.navigationController?.popViewControllerAnimated(true);
            } catch(_) {
                
            }
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
