//
//  WomenAmazonView.swift
//  TVShop
//
//  Created by admin on 1/23/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class WomenAmazonView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clickedCell = CatalogCell()
    var catalog = [Item]()
    var selectedCell = [CatalogCell]()
    
    var selectedIndex = Int()
    
    let URL_BASE = "https://s3.amazonaws.com/spicysuya/WomenJSON"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.startAnimating()
        
        downloadData()
        
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
                            let item = Item(itemDict: obj, type: "women")
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
            
            activityIndicator.stopAnimating()
            
            let item = catalog[indexPath.row]
            item.selectedCell = indexPath.row
            cell.configureCell(item)
            
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(WomenAmazonView.tapped(_:)))
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
            
            performSegueWithIdentifier("amazonCatalogDetails", sender: cell)
            
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
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.item
        
        print(selectedIndex)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let catalogDetailsVC = segue.destinationViewController as? AmazonViewController {
            if let theCell = sender as? CatalogCell {
                
                switch theCell.selectedIndex {
                    case 0:
                        catalogDetailsVC.searchProductCategory = "women formal gown"
                    case 1:
                        catalogDetailsVC.searchProductCategory = "women dress"
                    case 2:
                        catalogDetailsVC.searchProductCategory = "Women top dress"
                    case 3:
                        catalogDetailsVC.searchProductCategory = "Casual Skirt"
                    case 4:
                        catalogDetailsVC.searchProductCategory = "African women Dress"
                    case 5:
                        catalogDetailsVC.searchProductCategory = "yoga clothing"
                    case 6:
                        catalogDetailsVC.searchProductCategory = "Women Coat"
                    case 7:
                        catalogDetailsVC.searchProductCategory = "Women Dress Shoes"
                    case 8:
                        catalogDetailsVC.searchProductCategory = "Women Casual Shoes"
                    case 9:
                        catalogDetailsVC.searchProductCategory = "Women bag"
                    case 10:
                        catalogDetailsVC.searchProductCategory = "Women jewelry"
                    default:
                        print("ERROR: No catalog selected selected")
                }
            }
        }
        
    }
    
    
}
