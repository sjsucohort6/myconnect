//
//  School.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import Foundation
import Firebase

struct School {
    
    let schoolName: String
    let schoolKey: String
    var members: Set<String>
    
    init(
        schoolKey: String,
        schoolName: String) {
        self.schoolKey = schoolKey
        self.schoolName = schoolName
        members = Set<String>()
    }
    
    init(key: String, snapshot: FIRDataSnapshot) {
        schoolKey = key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        schoolName = snapshotValue["schoolName"] as! String
        members = Set<String>()
    }

    mutating func addMember(userId: String) {
        members.insert(userId)
    }

    func toAnyObject() -> Any {
        return [
            "schoolName": schoolName,
        ]
    }
    
}
