//
//  User.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 3/7/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import Parse

public class User: PFUser {
    
    private var _profilePicURL: NSURL?;
    var profilePicURL: NSURL? {
        get {
            if(_profilePicURL == nil) {
                let file = objectForKey("profilePicture") as? PFFile;
                
                let url = Post.getURLFromFile(file!);
                _profilePicURL = NSURL(string: url);
            }
            return _profilePicURL;
        }
        set {
            _profilePicURL = profilePicURL;
        }
    }

    var postsCount: Int? {
        let query = PFQuery(className: "Post");
        query.whereKey("author", equalTo: self);
        return query.countObjects(nil);
    }
    
    var followingCount: Int? {
        let query = PFQuery(className: "Follows");
        query.whereKey("follower", equalTo: self);
        return Int(query.countObjects(nil));
    }
    
    var followersCount: Int? {
        let query = PFQuery(className: "Follows");
        query.whereKey("followed", equalTo: self);
        return Int(query.countObjects(nil));
    }
    
    private var _isFollowed: Bool?;
    var isFollowed: Bool {
        if(_isFollowed == nil) {
            let query = PFQuery(className: "Follows");
            query.whereKey("followed", equalTo: self);
            query.whereKey("follower", equalTo: User.currentUser()!);
            _isFollowed = query.countObjects(nil) >= 1;
        }
        delay(1.0) { () -> () in
            self._isFollowed = nil;
        }
        return _isFollowed!;
    }
    
    public func follow(option: Bool) {
        if(option == true) {
            _isFollowed = true;
        } else {
            _isFollowed = false;
        }
        
        let query = PFQuery(className: "Follows");
        query.whereKey("follower", equalTo: User.currentUser()!);
        query.whereKey("followed", equalTo: self);
        let follows: [PFObject]?;
        do{
            try follows = query.findObjects();
            for follow in follows! {
                follow.deleteInBackground();
            }
        } catch(_) {
            
        }
        
        if(option == true) { // follow user
            let follow = PFObject(className: "Follows");
            follow["follower"] = User.currentUser();
            follow["followed"] = self;
            do{
                try follow.save();
            } catch (_) {
                
            }
        }
    }
    
    public func posts(offset: Int = 0, limit: Int = 20, completion: PFQueryArrayResultBlock) -> [Post]? {
        return Post.fetchPosts(offset, limit: limit, authorConstraint: self, completion: completion);
    }
    
    public class func getUserByUsername(username: String) -> User {
        let query = PFUser.query();
        query?.whereKey("username", equalTo: username);
        var result: PFObject?;

        do {
            result = try query!.getFirstObject();
        } catch(_) {
            
        }
        
        return result as! User;
    }
    
}
