//
//  PhotoUploadViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/26/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func savePhoto(_ sender: UIButton) {
        // upload the image
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.photoImageView.image!) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                // Store the image url into User's database
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    DataService.dataService.CURRENT_USER_REF.child("photos").child(imageName).setValue(profileImageUrl)
                }
            })
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(self.myUIImageViewTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        
        self.photoImageView.addGestureRecognizer(singleTap)
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.contentMode = .scaleToFill
        self.photoImageView.image = UIImage(named: "defaultPhoto")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        } else if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.photoImageView.contentMode = .scaleToFill
            self.photoImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
