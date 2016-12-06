//
//  ViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/25/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        if UserDefaults.standard.value(forKey: "uid") != nil
            && (FIRAuth.auth()?.currentUser != nil)
        {
            self.signedIn(FIRAuth.auth()?.currentUser!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailField.text,
            let password = passwordField.text
        else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("## Error signing in")
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
    }
    
    
    @IBAction func createAccount(_ sender: UIButton) {
    }
    
    func signedIn(_ user: FIRUser?) {
        
        UserDefaults.standard.setValue(user?.uid, forKey: "uid")

        self.performSegue(withIdentifier: "loggedIn", sender: nil)
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
}

