//
//  SchoolViewCell.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class SchoolViewCell: UITableViewCell {

    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var membersCountLabel: UILabel!
    
    var school: School!
    
    func configureCell(school: School) {
        self.school = school
        
        schoolNameLabel.text = school.schoolName
        membersCountLabel.text = String(school.members.count) + " Members"
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
