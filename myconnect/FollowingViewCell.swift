//
//  FollowingViewCell.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class FollowingViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var graduationYear: UILabel!
    
    @IBOutlet weak var schoolName: UILabel!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var userId: String!
    var userRef: FIRDatabaseReference!
    
    func configureCell(userId: String) {
        self.userId = userId
        self.userRef = DataService.dataService.USER_REF.child(userId)
        
        self.profilePhoto.image = UIImage(named: "defaultPhoto")
        self.profilePhoto.contentMode = .scaleToFill
        
        self.userRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let currentUser = User(snapshot: snapshot)
            
            self.userName.text = currentUser.firstName + " " + currentUser.lastName
            self.graduationYear.text = currentUser.graduationYear
            self.schoolName.text = currentUser.schoolKey
            
            if (currentUser.profilePhotoUrl != nil) {
                let url = URL(string: currentUser.profilePhotoUrl!)
                self.profilePhoto.sd_setImage(with: url)
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
