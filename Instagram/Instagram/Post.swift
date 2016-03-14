//
//  Post.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/6/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

public class Post: PFObject, PFSubclassing {

    public static func parseClassName() -> String {
        return "Post";
    }
    
    typealias BooleanCompletionClosure = (Bool) -> ();
    typealias IntCompletionClosure = (Int) -> ();
    typealias StringCompletionClosure = (String) -> ();
    typealias ObjectsCompletionClosure = ([PFObject]?) -> ();
    
    static var postCache: [String: Post] = [:];
    
    private var _mediaURL: NSURL?;
    var mediaURL: NSURL? {
        if(_mediaURL == nil) {
            let file = objectForKey("media") as? PFFile;
            
            let url = Post.getURLFromFile(file!);
            _mediaURL = NSURL(string: url);
        }
        return _mediaURL;
    }

    private var _author: User?;
    var author: User? {
        if(_author == nil) {
            _author = objectForKey("author") as? User;
        }
        return _author;
    }

    private var _caption: String?;
    var caption: String? {
        if(_caption == nil) {
            _caption = objectForKey("caption") as? String;
        }
        return _caption;
    }

    private var _likesCount: Int?;
    var likesCount: Int? {
        if(_likesCount == nil) {
            let likes = PFQuery(className:"Like")
            likes.whereKey("post", equalTo: self);
            _likesCount = likes.countObjects(nil);
        }
        return _likesCount;
    }
    
    private var _commentsCount: Int?;
    var commentsCount: Int? {
        if(_commentsCount == nil) {
            let comments = PFQuery(className:"Comment")
            comments.whereKey("post", equalTo: self);
            _commentsCount = comments.countObjects(nil);
        }
        return _commentsCount;
    }
    
    private var _comments: [PFObject]?;
    var comments: [PFObject]? {
        if(_comments == nil) {
            let query = PFQuery(className:"Comment")
            query.whereKey("post", equalTo: self);
            query.includeKey("user");
            var results: [PFObject]?;
            do {
                results = try query.findObjects();
            } catch(_) {
                
            }
            _comments = results;
        }
        return _comments;
    }
    
    var _liked: Bool?;
    var liked: Bool {
        get {
            if(User.currentUser() == nil) {
                return false;
            }
            if(_liked == nil) {
                let likes = PFQuery(className:"Like")
                likes.whereKey("user", equalTo: User.currentUser()!);
                likes.whereKey("post", equalTo: self);
                _liked = likes.countObjects(nil) > 0;
            }
            return _liked!;
        }
        set {
            if(liked) {
                let likes = PFQuery(className:"Like")
                likes.whereKey("user", equalTo: User.currentUser()!);
                likes.whereKey("post", equalTo: self);
                likes.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    if(objects != nil) {
                        for object in objects! {
                            object.deleteEventually();
                        }
                    }
                }
                _liked = false;
            } else {
                let like = PFObject(className: "Like")
                like.setObject(User.currentUser()!, forKey: "user")
                like.setObject(self, forKey: "post")
                like.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if(!success) {
                        print(error?.localizedDescription);
                    }
                }
                _liked = true;
            }
        }
    }
    
     /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    init(image: UIImage?, var withCaption captionText: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        if(captionText == nil) {
            captionText = "";
        }
        
        let media = Post.generateFileFromImage(image!);
        
        super.init();
        
        self["media"] = media;
        self["author"] = PFUser.currentUser()!; // Pointer column type that points to PFUser
        self["caption"] = captionText!;
        
        // Save object (following function will save the object in Parse asynchronously)
        saveInBackgroundWithBlock(completion);
    }
    
    override public init() {
        super.init();
        
        if let objectId = objectId {
            if(Post.postCache[objectId] != nil) {
                _liked = Post.postCache[objectId]!._liked;
                _likesCount = Post.postCache[objectId]!._likesCount;
                _commentsCount = Post.postCache[objectId]!._commentsCount;
                _comments = Post.postCache[objectId]!._comments;
                _mediaURL = Post.postCache[objectId]!._mediaURL;
            } else {
                Post.postCache[objectId] = self;
            }
        }
    }
    
    func getCachedLiked(completion: BooleanCompletionClosure? = nil) -> Bool {
        if(_liked == nil) {
            return liked;
        }
        
        if(completion != nil){
            delay(0.3) { () -> () in // asynchronous
                completion!(self.liked);
            }
        }
        
        return _liked!;
    }
    
    func getCachedLikesCount(completion: IntCompletionClosure? = nil) -> Int? {
        if(_likesCount == nil) {
            return likesCount;
        }
        
        if(completion != nil){
            delay(0.2) { () -> () in // asynchronous
                completion!(self.likesCount!);
            }
        }
        
        return _likesCount;
    }
    
    func getCachedCommentsCount(completion: IntCompletionClosure? = nil) -> Int? {
        if(_commentsCount == nil) {
            return commentsCount;
        }
        
        if(completion != nil) {
            delay(0.1) { () -> () in // asynchronous
                completion!(self.commentsCount!);
            }
        }
        
        return _commentsCount;
    }
    
    func getCachedComments(completion: ObjectsCompletionClosure? = nil) -> [PFObject]? {
        if(_comments == nil) {
            return comments;
        }
        
        if(completion != nil) {
            delay(0.4) { () -> () in // asynchronous
                completion!(self.comments);
            }
        }
        
        return _comments;
    }
    
    func buffer() {
        delay(0.1) { () -> () in
            self.getCachedComments();
            self.getCachedCommentsCount();
            self.getCachedLiked();
            self.getCachedLikesCount();
            let ephemeralImageView = UIImageView();
            ephemeralImageView.setImageWithURL(self.mediaURL!);
        }
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func generateFileFromImage(image: UIImage) -> PFFile {
        return PFFile(name: "image.png", data: UIImagePNGRepresentation(image)!)!;
    }
    
    class func setFileToImageView(image: PFFile, imageView: UIImageView) {
        image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data:imageData!);
                imageView.image = image;
            }
        }
    }
    
    override public class func query(/*predicate: NSPredicate? = nil*/) -> PFQuery? {
        return PFQuery(className: "Post"/*, predicate: predicate*/);
    }
    
    class func getURLFromFile(file: PFFile) -> String {
        // don't wanna make an App Transport Security exception :/
        return file.url!.replace("http://", withString: "https://");
    }

    class func fetchPosts(offset: Int = 0, limit: Int = 20, authorConstraint: User? = nil, completion: PFQueryArrayResultBlock) -> [Post]? {
        assert(limit <= 20);
        assert(offset >= 0);
        
        let query = PFQuery(className: "Post");
        query.limit = limit;
        query.skip = offset;
        query.orderByDescending("createdAt");
        query.includeKey("author");
        
        if(authorConstraint != nil) {
            query.whereKey("author", equalTo: authorConstraint!);
        }
        
        var results: [PFObject]?;
        
        do {
            results = try query.findObjects();
        } catch(_) {
            
        }
        
        completion(results, nil);
        
        return results as! [Post]?;
    }
    
    public func comment(contentText: String, block: PFBooleanResultBlock? = nil) {
        let comment = PFObject(className: "Comment")
        comment.setObject(User.currentUser()!, forKey: "user")
        comment.setObject(self, forKey: "post")
        comment.setObject(contentText, forKey: "content");
        comment.saveInBackgroundWithBlock(block);
    }
    
    class func lowestReached(unit: String, value: Double) -> Bool {
        let value = Int(round(value));
        switch unit {
        case "s":
            return value < 60;
        case "m":
            return value < 60;
        case "h":
            return value < 24;
        case "d":
            return value < 7;
        case "w":
            return value < 4;
        default: // include "w". cannot reduce weeks
            return true;
        }
    }
    
    class func timeSince(date: NSDate) -> String {
        var unit = "s";
        var timeSince = abs(date.timeIntervalSinceNow as Double); // in seconds
        let reductionComplete = lowestReached(unit, value: timeSince);
        
        while(reductionComplete != true){
            unit = "m";
            timeSince = round(timeSince / 60);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "h";
            timeSince = round(timeSince / 60);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "d";
            timeSince = round(timeSince / 24);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "w";
            timeSince = round(timeSince / 7);
            if lowestReached(unit, value: timeSince) { break; }
            
            (unit, timeSince) = localizedDate(date);   break;
        }
        
        let value = Int(timeSince);
        return "\(value)\(unit)";
    }
    
    class func localizedDate(date: NSDate) -> (unit: String, timeSince: Double) {
        var unit = "/";
        let formatter = NSDateFormatter();
        formatter.dateFormat = "M";
        let timeSince = Double(formatter.stringFromDate(date))!;
        formatter.dateFormat = "d/yy";
        unit += formatter.stringFromDate(date);
        return (unit, timeSince);
    }
    
    class func shortenNumber(var number: Double) -> String {
        if(number > 999999999) {
            number = number/1000000000;
            return String(format: "%.1f", number) + "B";
        }
        if(number > 999999) {
            number = number/1000000;
            return String(format: "%.1f", number) + "M";
        }
        if(number > 9999) {
            number = number/1000;
            return String(format: "%.1f", number) + "K";
        }
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        return numberFormatter.stringFromNumber(number)!;
    }

}
