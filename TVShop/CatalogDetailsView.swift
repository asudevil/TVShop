//
//  CatalogDetailsView.swift
//  TVShop
//
//  Created by admin on 1/3/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CatalogDetailsView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var catagory = ""
    
    var URL_BASE = ""
    
    var catalog = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        downloadData()
        
        print("downloadData is running!!")
        
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
                                
                                let item = Item(itemDict: obj, type: self.catagory)
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
            
            let item = catalog[indexPath1.row]
            cell1.configureCell(item)
            
            if cell1.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(CatalogDetailsView.tapped(_:)))
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
            
            print("You tapped on an item in the kids catalog")
            
            performSegueWithIdentifier("itemDetails", sender: cell)
            
        }
    }
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(630, 830)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let itemDetailsVC = segue.destinationViewController as? ItemDetailsView {
            
            if let theCell = sender as? CatalogCell {
        
                
                if let title = theCell.itemLbl.text {
                    itemDetailsVC.clickedItemTitle = title
                }
                
                if let image = theCell.itemImg.image {
                    itemDetailsVC.clickedImage = image
                    itemDetailsVC.clickedSideImage1 = image
         //           itemDetails.clickedSideImage2 = image  // testing out side image
                    itemDetailsVC.clickedSideImage3 = image
                }

                
           // testing side image
                itemDetailsVC.clickedSideImage2 = theCell.setSideImage
                
                itemDetailsVC.clickedItemCategory = theCell.itemDesc
                }
        }
    
    }
    
}
