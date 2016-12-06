//
//  FeedViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/26/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
            // Be sure that the tableView updates when there is new data.
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        
        // We are using a custom cell.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? FeedCommentViewCell {
            
            cell.configureCell(comment: comment)
            return cell
        } else {
            return FeedCommentViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
