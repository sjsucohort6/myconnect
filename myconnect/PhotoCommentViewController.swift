//
//  PhotoCommentViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 12/3/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class PhotoCommentViewController: UIViewController {

    @IBOutlet weak var photoDetailView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func postComment(_ sender: UIButton) {
        let commentPosted = commentTextField.text
        
        if commentPosted != "" {
            
            let comment = Comment(
                comment: commentPosted!,
                photoUrl: photoUrl!,
                firstName: currentUser.firstName,
                lastName: currentUser.lastName,
                schoolName: currentUser.schoolKey,
                profilePhotoUrl: currentUser.profilePhotoUrl,
                likesCount: 0,
                dislikesCount: 0)
            
            // Send it over to DataService to seal the deal.
            DataService.dataService.createNewCommnet(comment: comment)
            
            performSegue(withIdentifier: "photoCommentPosted", sender: nil)
        }
    }
    
    var currentUser: User!
    var photoUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: photoUrl!)
        self.photoDetailView.sd_setImage(with: url!)
        self.photoDetailView.contentMode = .scaleToFill
        
        // Do any additional setup after loading the view.
        DataService.dataService.CURRENT_USER_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.currentUser = User(snapshot: snapshot)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
