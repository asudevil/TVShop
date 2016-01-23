//
//  MenViewController.swift
//  TVShop
//
//  Created by admin on 12/31/15.
//  Copyright © 2015 CodeWithFelix. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class MenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clickedCell = CatalogCell()
    
    let URL_BASE = "https://s3.amazonaws.com/spicysuya/MenJSON"
    
    var catalog = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        downloadData()

        // Do any additional setup after loading the view.
    }
    
    func downloadData() {
        
        //NOTE: All this should be in a seperate class for download manager class
        
        let url = NSURL(string: URL_BASE)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ (data, request, error) -> Void in
    
            if error != nil {
                print(error.debugDescription)
            } else {
                
                do {
                    
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Dictionary<String, AnyObject>
                    
                    if let results = dict!["results"] as? [Dictionary<String, AnyObject>]{
            
                        for obj in results {
                            let item = Item(itemDict: obj, type: "men")
                            self.catalog.append(item)
                            
                        }
                        
                        //Main UI thread
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView.reloadData()
                        }
                    }
                    
                } catch {
                    
                }
            }
            
        }
        task.resume()
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath) as? CatalogCell {
            
            let item = catalog[indexPath.row]
            cell.configureCell(item)
            
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
            }
            
            
            return cell
            
        } else {
            
            return CatalogCell()
        }
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? CatalogCell {
            //Load the next view controller and pass in the catalog
            
            clickedCell = cell
            
            print("You tapped on a men catalog")
            
            performSegueWithIdentifier("catalogDetails", sender: self)
            
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(450, 541)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let catalogDetails = segue.destinationViewController as! CatalogDetailsView
        
        if let title = clickedCell.itemLbl.text {

            if title == "Jackets" {
                
                catalogDetails.URL_BASE = "https://s3.amazonaws.com/spicysuya/menJacketJSON"
                catalogDetails.catagory = "Jacket"
            }
        }
    }


}
