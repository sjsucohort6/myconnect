//
//  SchoolTableViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/27/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class SchoolTableViewController: UITableViewController {
    
    var schools = [School]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.SCHOOLS_REF.observe(FIRDataEventType.value, with: { snapshot in
            
            // The snapshot is a current look at our comments data.
            self.schools = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our comments array for the tableView.
                    let school = School(key: snap.key, snapshot: snap)
                    
                    // Items are returned chronologically, but it's more fun with the newest comments first.
                    self.schools.insert(school, at: 0)
                }
                
            }
            DataService.dataService.USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshots {
                        
                        // Make our comments array for the tableView.
                        let user = User(snapshot: snap)
                        
                        for i in 0 ..< self.schools.count {
                            if(self.schools[i].schoolKey == user.schoolKey) {
                                self.schools[i].addMember(userId: snap.key)
                            }
                        }
                    }
                }
                // Be sure that the tableView updates when there is new data.
                self.tableView.reloadData()
            })
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
        return schools.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let school = schools[indexPath.row]
        
        // We are using a custom cell.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolViewCell") as? SchoolViewCell {
            cell.configureCell(school: school)
            return cell
        } else {
            return SchoolViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMembersSegue" {
            if let destinationVC = segue.destination as? SchoolMembersViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC.members = self.schools[indexPath.row].members.sorted()
                }
            }
        }
    }
}
