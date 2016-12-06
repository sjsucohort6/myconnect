//
//  FollowersViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class FollowersViewController: UITableViewController {

    var users = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("### Inside FollowersViewController")
        DataService.dataService.CURRENT_USER_FOLLOWERS_REF.observe(FIRDataEventType.value, with: { snapshot in
            
            print("### snapshot " + String(describing: snapshot))
            // The snapshot is a current look at our comments data.
            self.users = []
            
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                for userId in snapshotValue.keys {
                    print("### " + userId)
                    self.users.insert(userId, at: 0)
                }
            }
            
            // Be sure that the tableView updates when there is new data.
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userId = users[indexPath.row]
        
        // We are using a custom cell.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerViewCell") as? FollowerViewCell {
            cell.configureCell(userId: userId)
            return cell
        } else {
            return SchoolMemberViewCell()
        }
    }
}
