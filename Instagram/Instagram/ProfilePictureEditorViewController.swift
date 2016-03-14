//
//  ProfilePictureEditorViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/12/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class ProfilePictureEditorViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
