//
//  CreateAccountViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/25/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase
import ActionSheetPicker_3_0

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    let schoolKeys = [
        "Fremont School" : "FremontSchool",
        "Sunnyvale School" : "SunnyvaleSchool",
        "Milpitas School" : "MilpitasSchool"
    ]
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var schoolKey: String?
    @IBOutlet weak var schoolButton: UIButton!
    
    @IBAction func schoolButtonClicked(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(
            title: "School",
            rows: [["Fremont School", "Sunnyvale School", "Milpitas School"],],
            initialSelection: [0],
            doneBlock: {
                picker, values, indexes in
                
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                
                if let selected = indexes as? [String]? {
                    self.schoolKey = self.schoolKeys[selected![0]]
                    print(selected![0])
                    self.schoolButton.setTitle(selected![0], for: UIControlState.normal)
                }
                return
            },
            cancel: { ActionMultipleStringCancelBlock in return },
            origin: sender)
        
        acp?.setTextColor(UIColor.black)
        acp?.pickerBackgroundColor = UIColor.gray
        acp?.toolbarBackgroundColor = UIColor.brown
        acp?.toolbarButtonsColor = UIColor.white
        acp?.show()
    }
    
    var graduationYear: String?
    @IBOutlet weak var graduationYearButton: UIButton!
    @IBAction func graduationYearClicked(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(
            title: "Graduation Year",
            rows: [["2015 (Senior)", "2016 (Junior)", "2017 (Sophomore)", "2018 (Freshman)"],],
            initialSelection: [0],
            doneBlock: {
                picker, values, indexes in
                
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                
                if let selected = indexes as? [String]? {
                    self.graduationYear = selected![0]
                    print(self.graduationYear!)
                    self.graduationYearButton.setTitle(self.graduationYear, for: UIControlState.normal)
                }
                return
            },
            cancel: { ActionMultipleStringCancelBlock in return },
            origin: sender)
        
        acp?.setTextColor(UIColor.black)
        acp?.pickerBackgroundColor = UIColor.gray
        acp?.toolbarBackgroundColor = UIColor.brown
        acp?.toolbarButtonsColor = UIColor.white
        acp?.show()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailAddressField.text,
            let password = passwordField.text
        else {
            return
        }
            
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // If the new account was successfully created, the user is signed in,
            // and you can get the user's account data from the user object that's 
            // passed to the callback method.
            // Please refer to https://firebase.google.com/docs/auth/ios/password-auth
            
            self.createAccount(user)
            self.updateAppState(user)
            self.performSegue(withIdentifier: "signUpComplete", sender: nil)
        }
    }
    
    @IBAction func cancelSignup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateAppState(_ user: FIRUser?) {
        UserDefaults.standard.setValue(user?.uid, forKey: "uid")
    }
    
    func createAccount(_ user: FIRUser?) {
        guard
            let emailAddress = emailAddressField.text,
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let graduationYear = self.graduationYear,
            let schoolKey = self.schoolKey
        else {
            return
        }
        
        let userDetails = User(
            emailAddress: emailAddress,
            firstName: firstName,
            lastName: lastName,
            graduationYear: graduationYear,
            schoolKey: schoolKey)
        
        DataService.dataService.createNewAccount(uid: (user?.uid)!, user: userDetails)
    }

}
