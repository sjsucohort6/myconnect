//
//  FriendsViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var followingView: UIView!
    
    @IBOutlet weak var followingMeView: UIView!
    
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.followingView.alpha = 1
                self.followingMeView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.followingView.alpha = 0
                self.followingMeView.alpha = 1
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
