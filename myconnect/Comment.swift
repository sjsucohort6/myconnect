//
//  Comment.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/26/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Foundation
import Firebase

struct Comment {
    
    let key: String?
    
    let comment: String
    let photoUrl: String?
    
    let firstName: String
    let lastName: String
    let schoolName: String
    let profilePhotoUrl: String?
    
    let likesCount: Int
    let dislikesCount: Int
    
    init(
        comment: String,
        photoUrl: String?,
        firstName: String,
        lastName: String,
        schoolName: String,
        profilePhotoUrl: String?,
        likesCount: Int,
        dislikesCount: Int) {
        self.comment = comment
        self.photoUrl = photoUrl
        self.firstName = firstName
        self.lastName = lastName
        self.schoolName = schoolName
        self.profilePhotoUrl = profilePhotoUrl
        self.likesCount = likesCount
        self.dislikesCount = dislikesCount
        self.key = nil
    }
    
    init(key: String, snapshot: FIRDataSnapshot) {
        self.key = key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        comment = snapshotValue["comment"] as! String
        photoUrl = snapshotValue["photo"] as? String
        
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        schoolName = snapshotValue["schoolName"] as! String
        profilePhotoUrl = snapshotValue["profilePhoto"] as? String
        
        likesCount = snapshotValue["likesCount"] as! Int
        dislikesCount = snapshotValue["dislikesCount"] as! Int
    }
    
    func toAnyObject() -> Any {
        var jsonData = [
            "comment": comment,
            "firstName": firstName,
            "lastName": lastName,
            "schoolName": schoolName,
            "likesCount": likesCount,
            "dislikesCount": dislikesCount
        ] as [String : Any]
        
        if (photoUrl != nil) {
            jsonData.updateValue(photoUrl!, forKey: "photo")
        }
        
        if (profilePhotoUrl != nil) {
            jsonData.updateValue(profilePhotoUrl!, forKey: "profilePhoto")
        }
        return jsonData
    }
    
}
