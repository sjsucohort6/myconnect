//
//  User.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/25/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let emailAddress: String
    let firstName: String
    let lastName: String
    let graduationYear: String
    let schoolKey: String
    let profilePhotoUrl: String?
    
    init(
        emailAddress: String,
        firstName: String,
        lastName: String,
        graduationYear: String,
        schoolKey: String) {
        self.emailAddress = emailAddress
        self.firstName = firstName
        self.lastName = lastName
        self.graduationYear = graduationYear
        self.schoolKey = schoolKey
        self.profilePhotoUrl = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        emailAddress = snapshotValue["emailAddress"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        graduationYear = snapshotValue["graduationYear"] as! String
        schoolKey = snapshotValue["schoolkey"] as! String
        profilePhotoUrl = snapshotValue["profilePhoto"] as? String
    }
    
    func toAnyObject() -> Any {
        var jsonData = [
            "emailAddress": emailAddress,
            "firstName": firstName,
            "lastName": lastName,
            "graduationYear": graduationYear,
            "schoolkey": schoolKey,
        ]
        
        if (profilePhotoUrl != nil) {
            jsonData.updateValue(profilePhotoUrl!, forKey: "profilePhoto")
        }
        
        return jsonData
    }
    
}
