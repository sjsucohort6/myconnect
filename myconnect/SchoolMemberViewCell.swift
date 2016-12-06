//
//  SchoolMemberViewCell.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class SchoolMemberViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    var userId: String!
    var userRef: FIRDatabaseReference!
    
    @IBAction func followMember(_ sender: Any) {
        DataService.dataService.follow(userId: self.userId)
    }
    
    func configureCell(userId: String) {
        self.userId = userId
        self.userRef = DataService.dataService.USER_REF.child(userId)
        
        self.profilePhotoView.image = UIImage(named: "defaultPhoto")
        self.profilePhotoView.contentMode = .scaleToFill
        
        self.userRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let currentUser = User(snapshot: snapshot)
            
            self.memberNameLabel.text = currentUser.firstName + " " + currentUser.lastName
            
            if (currentUser.profilePhotoUrl != nil) {
                let url = URL(string: currentUser.profilePhotoUrl!)
                self.profilePhotoView.sd_setImage(with: url)
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
