//
//  DataService.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/25/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class DataService: NSObject {
    static let dataService = DataService()
    
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _USER_REF = FIRDatabase.database().reference(withPath: "users")
    private var _FEED_REF = FIRDatabase.database().reference(withPath: "feed")
    private var _SCHOOLS_REF = FIRDatabase.database().reference(withPath: "schools")
    
    private var _FOLLOWERS_REF = FIRDatabase.database().reference(withPath: "followers")
    private var _FOLLOWING_REF = FIRDatabase.database().reference(withPath: "following")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        
        let currentUser = _USER_REF.child(userID)
        
        return currentUser
    }
    
    var CURRENT_USER_PHOTOS_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        
        let photosRef = _USER_REF.child(userID).child("photos")
        
        return photosRef
    }
    
    var FEED_REF: FIRDatabaseReference {
        return _FEED_REF
    }
    
    var SCHOOLS_REF: FIRDatabaseReference {
        return _SCHOOLS_REF
    }
    
    var CURRENT_USER_FOLLOWERS_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        return _FOLLOWERS_REF.child(userID)
    }
    
    var CURRENT_USER_FOLLOWING_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        return _FOLLOWING_REF.child(userID)
    }
    
    func createProfilePhoto(photoUrl: String) {
        // create account details
        CURRENT_USER_REF.child("profilePhoto").setValue(photoUrl)
    }
    
    func createNewAccount(uid: String, user: User) {
        // create account details
        USER_REF.child(uid).setValue(user.toAnyObject())
    }
    
    func createNewCommnet(comment: Comment) {
        // Save the Joke
        // JOKE_REF is the parent of the new Joke: "jokes".
        // childByAutoId() saves the joke and gives it its own ID.
        let commentRef = FEED_REF.childByAutoId()
        
        // setValue() saves to Firebase.
        commentRef.setValue(comment.toAnyObject())
    }
    
    func follow(userId: String) {
        // Follower is the current user
        let followerUserId = UserDefaults.standard.value(forKey: "uid") as! String
        
        _FOLLOWERS_REF.child(userId).setValue([followerUserId : followerUserId])
        _FOLLOWING_REF.child(followerUserId).setValue([userId : userId])
    }
}
