//
//  KidsViewController.swift
//  TVShop
//
//  Created by admin on 12/31/15.
//  Copyright © 2015 CodeWithFelix. All rights reserved.
//

import UIKit

class KidsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var clickedCell = CatalogCell()
    
    let URL_BASE = "https://s3.amazonaws.com/spicysuya/KidsJSON"
    
    var catalog = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.startAnimating()
        
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
                            let item = Item(itemDict: obj, type: "kids")
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
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath1: NSIndexPath) -> UICollectionViewCell {
        
        if let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath1) as? CatalogCell {
            
            activityIndicator.stopAnimating()
            
            let item = catalog[indexPath1.row]
            cell1.configureCell(item)
            
            if cell1.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell1.addGestureRecognizer(tap)
            }
            
            return cell1
            
        } else {
            
            return CatalogCell()
        }
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? CatalogCell {
            //Load the next view controller and pass in the catalog
            
            clickedCell = cell
            
            print("You tapped on a catalog")
            
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
        
        if let catalogDetails = segue.destinationViewController as? CatalogDetailsView {

            if let title = clickedCell.itemLbl.text {
                
                if title == "Toddler" {
            
                    catalogDetails.URL_BASE = "https://s3.amazonaws.com/spicysuya/ToddlerCatalogJSON"
                    catalogDetails.catagory = "toddler"
                }
            }
        }
    }
}
