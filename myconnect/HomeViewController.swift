//
//  HomeViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/25/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var containerViewA: UIView!
    
    @IBOutlet weak var containerViewB: UIView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var graduationYear: UILabel!
    
    @IBOutlet weak var schoolName: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            
            // Remove the user's uid from storage.
            UserDefaults.standard.setValue(nil, forKey: "uid")
            
            // Head back to Login!
            let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            
    
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(self.myUIImageViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        
        self.profileImageView.addGestureRecognizer(singleTap)
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.contentMode = .scaleToFill
        self.profileImageView.image = UIImage(named: "defaultPhoto")
        
        DataService.dataService.CURRENT_USER_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let currentUser = User(snapshot: snapshot)
            
            self.fullNameLabel.text = currentUser.firstName + " " + currentUser.lastName
            self.graduationYear.text = currentUser.graduationYear
            self.schoolName.text = currentUser.schoolKey
            
            if (currentUser.profilePhotoUrl != nil) {
                let url = URL(string: currentUser.profilePhotoUrl!)
                self.profileImageView.sd_setImage(with: url)
            }
        })
    }
    
    func myUIImageViewTapped(_ sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.ended){
            
            // create the alert
            let alert = UIAlertController(
                title: "MyConnect",
                message: "What would you like to upload",
                preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { action in
                
                self.captureNewImageFromCamera()
                
            }))
            alert.addAction(UIAlertAction(title: "Photo", style: UIAlertActionStyle.default, handler: { action in
                
                self.loadPhotoFromLibrary()
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func captureNewImageFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    func loadPhotoFromLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        } else if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.contentMode = .scaleToFill
            self.profileImageView.image = selectedImage
            saveProfileImage(profileImage: selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveProfileImage(profileImage: UIImage) {
        if let uploadData = UIImagePNGRepresentation(profileImage) {
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).png")
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                // Store the image url into User's database
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    DataService.dataService.createProfilePhoto(photoUrl: profileImageUrl)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
