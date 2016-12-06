//
//  PostCommentViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/26/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class PostCommentViewController: UIViewController {

    @IBOutlet weak var commentText: UITextView!
    
    var currentUser: User!
    
    
    @IBAction func postComment(_ sender: Any) {
        let commentPosted = commentText.text
        
        if commentPosted != "" {
            
            let comment = Comment(
                comment: commentPosted!,
                photoUrl: nil,
                firstName: currentUser.firstName,
                lastName: currentUser.lastName,
                schoolName: currentUser.schoolKey,
                profilePhotoUrl: currentUser.profilePhotoUrl,
                likesCount: 0,
                dislikesCount: 0)
            
            // Send it over to DataService to seal the deal.
            DataService.dataService.createNewCommnet(comment: comment)
            
            performSegue(withIdentifier: "postedComment", sender: nil)
        }
    }
    
    @IBAction func clearComment(_ sender: UIButton) {
        commentText.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
