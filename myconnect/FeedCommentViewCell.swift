//
//  FeedCommentViewCell.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/26/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class FeedCommentViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var commentPhoto: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    var comment: Comment!
    var voteRef: FIRDatabaseReference!
    
    @IBAction func likeComment(_ sender: UIButton) {
        voteRef.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            let latestComment = Comment(key: snapshot.key, snapshot: snapshot)
            self.voteRef.child("likesCount").setValue(latestComment.likesCount + 1)
        })
    }
    
    @IBAction func dislike(_ sender: UIButton) {
        voteRef.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            let latestComment = Comment(key: snapshot.key, snapshot: snapshot)
            self.voteRef.child("dislikesCount").setValue(latestComment.dislikesCount + 1)
        })
    }
    
    func configureCell(comment: Comment) {
        self.comment = comment
        
        // Set the labels and textView.
        self.textView.text = comment.comment
        self.userLabel.text = comment.firstName + " " + comment.lastName
        
        print("### configuring cell")
        print(comment)
        if (comment.photoUrl != nil) {
            print("### url " + comment.photoUrl!)
            let url = URL(string: comment.photoUrl!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if (error != nil) {
                    print("### error ")
                    print(error!)
                    return
                }
                
                DispatchQueue.global().async(execute: {
                    print("### setting image ")
                    self.commentPhoto.image = UIImage(data: data!)
                    self.commentPhoto.contentMode = .scaleToFill
                })
            }).resume()
        }
        // self.likes.text = "Total likes: \(comment.likesCount)"
        
        voteRef = DataService.dataService.FEED_REF.child(comment.key!)
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
