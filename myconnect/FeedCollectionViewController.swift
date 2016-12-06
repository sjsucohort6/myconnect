//
//  FeedCollectionViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 12/4/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

private let cellId = "cellId"
private let reuseIdentifier = "Cell"

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Myconnect Feed"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        DataService.dataService.FEED_REF.observe(FIRDataEventType.value, with: { snapshot in
            
            // The snapshot is a current look at our comments data.
            self.comments = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our comments array for the tableView.
                    let comment = Comment(key: snap.key, snapshot: snap)
                    
                    // Items are returned chronologically, but it's more fun with the newest jokes first.
                    self.comments.insert(comment, at: 0)
                }
                
            }
            
            // Be sure that the collection view updates when there is new data.
            self.collectionView?.reloadData()
        })

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! FeedCell
        
        feedCell.setup(comment: self.comments[(indexPath as NSIndexPath).row])
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = self.comments[(indexPath as NSIndexPath).row]
        if (comment.photoUrl != nil) {
            return CGSize(view.frame.width, 400)
        } else {
            return CGSize(view.frame.width, 180)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

class FeedCell: UICollectionViewCell {
    
    var comment: Comment?
    var voteRef: FIRDatabaseReference!
    
    var nameLabel: UILabel?
    var statusImageView: UIImageView?
    var likesCommentsLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(comment: Comment) {
        self.comment = comment
        voteRef = DataService.dataService.FEED_REF.child(comment.key!)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNameLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        
        let fullName = (self.comment?.firstName)! + " " + (self.comment?.lastName)!
        let attributedText = NSMutableAttributedString(string: fullName, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\n" + (self.comment?.schoolName)!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName:
            UIColor.rgb(red: 155, green: 161, blue: 161)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        label.attributedText = attributedText
        
        return label
    }
    
    func getProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        
        if (comment?.profilePhotoUrl != nil) {
            let url = URL(string: (self.comment?.profilePhotoUrl!)!)
            imageView.sd_setImage(with: url)
            imageView.contentMode = .scaleToFill
        } else {
            imageView.image = UIImage(named: "defaultPhoto")
            imageView.contentMode = .scaleToFill
        }
        
        return imageView
    }
    
    func getStatusTextView() -> UITextView {
        let textView = UITextView()
        textView.text = self.comment?.comment
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }
    
    func getStatusImageView() -> UIImageView {
        let imageView = UIImageView()
        
        if (comment?.photoUrl != nil) {
            let url = URL(string: (self.comment?.photoUrl!)!)
            imageView.sd_setImage(with: url)
        }
        
        return imageView
    }
    
    func getLikesCommentsLabel() ->UILabel {
        let likesCount:Int = (self.comment?.likesCount)!
        let dislikesCount:Int = (self.comment?.dislikesCount)!
        let label = UILabel()
        label.text = "\(likesCount) Likes   \(dislikesCount) Dislikes"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    func buttonClicked(sender: UIButton!) {
        print("click")
        self.voteRef.child("likesCount").setValue((self.comment?.likesCount)! + 1)
    }
    
    func getLikeButton(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(self.buttonClicked), for: UIControlEvents.touchUpInside)
        return button
    }
    
    override func prepareForReuse() {
        if (self.likesCommentsLabel != nil) {
            self.likesCommentsLabel?.text = ""
        }
        
        if (self.statusImageView != nil) {
            self.statusImageView?.image = nil
        }
        
        if (self.nameLabel != nil) {
            self.nameLabel?.text = ""
        }
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        self.nameLabel = getNameLabel()
        addSubview(self.nameLabel!)
        
        let profileImageView = getProfileImageView()
        addSubview(profileImageView)
        
        let statusTextView = getStatusTextView()
        addSubview(statusTextView)
        
        
        if (self.comment?.photoUrl != nil) {
            self.statusImageView = getStatusImageView()
            addSubview(statusImageView!)
            addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView!)
        }
        
        self.likesCommentsLabel = getLikesCommentsLabel()
        addSubview(likesCommentsLabel!)
        addSubview(dividerLineView)
        
        let likeButton = getLikeButton(title: "Like", imageName: "like")
        addSubview(likeButton)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel!)
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel!)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        //button constraints
        addConstraintsWithFormat(format: "H:|-4-[v0]|", views: likeButton)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel!)
        
        if (statusImageView != nil) {
            addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(30)]-4-[v2]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView!, likesCommentsLabel!, dividerLineView, likeButton)
        } else {
            addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(30)]-8-[v2(24)]-8-[v3(0.4)][v4(44)]|", views: profileImageView, statusTextView, likesCommentsLabel!, dividerLineView, likeButton)
        }
        
    }
    
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
