//
//  MyPhotosViewController.swift
//  myconnect
//
//  Created by indu Ponnapa Reddy on 11/30/16.
//  Copyright © 2016 indu Ponnapa Reddy. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MyPhotoCell"
private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

class MyPhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var myPhotosUrls = [String]()
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.CURRENT_USER_PHOTOS_REF.observe(FIRDataEventType.value, with: { snapshot in
            
            // The snapshot is a current look at our comments data.
            self.myPhotosUrls = []
            
            print(snapshot)
            if let snapshotValue = snapshot.value as? [String: String] {
                for photoUrl in snapshotValue.values {
                    self.myPhotosUrls.insert(photoUrl, at: 0)
                    // let url = URL(string: photoUrl)
                    // self.downloadImage(url: url!)
                }
            } else {
                print("unable to get snapshot as value")
            }
            
            // Be sure that the tableView updates when there is new data.
            self.collectionView?.reloadData()
        })
        
        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.global().async() { () -> Void in
                self.myPhotosImages[url.absoluteString] = UIImage(data: data)
                self.collectionView?.reloadData()
            }
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    // tell the collection view how many cells to make
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotosUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("### indexPath")
        print(indexPath)
        
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! MyPhotoViewCell
        //2
        let photoUrl = myPhotosUrls[(indexPath as NSIndexPath).row]
        
        let url = URL(string: photoUrl)
        cell.photoImageView.sd_setImage(with: url)
        cell.photoImageView.contentMode = .scaleToFill

        /*
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                cell.photoImageView.image = UIImage(data: data!)
                cell.photoImageView.contentMode = .scaleToFill
            })
        }).resume()
        */
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("## Did select item at")
//        self.performSegue(withIdentifier: "photoCommentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "photoCommentSegue") {
            print("## Inside segue")
            if let destinationVC = segue.destination as? PhotoCommentViewController {
//                let selectedPhotoViewCell = sender as? MyPhotosViewController
                let indexPath = self.collectionView.indexPathsForSelectedItems?.first
                let cell = self.collectionView.cellForItem(at: indexPath!)
                print(indexPath!)
                print(indexPath!.item)
                if (cell == nil) {
                    print("### cel is nil")
                }
                if (destinationVC.photoDetailView == nil) {
                    print("## destinationVC.photoDetailView is nil")
                }
                
                destinationVC.photoUrl = self.myPhotosUrls[indexPath!.item]
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
