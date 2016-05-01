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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var clickedCell = CatalogCell()
    var catalog = [Item]()
    var selectedCell = [CatalogCell]()
    
    var selectedIndex = Int()
    
    let URL_BASE = "https://s3.amazonaws.com/spicysuya/MenJSON"
    
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
            
            activityIndicator.stopAnimating()
            
            let item = catalog[indexPath.row]
            item.selectedCell = indexPath.row
            cell.configureCell(item)
            
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(MenViewController.tapped(_:)))
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
        
        if let menCatalogDetailsVC = segue.destinationViewController as? AmazonViewController {
            if let theCell1 = sender as? CatalogCell {
                
                switch theCell1.selectedIndex {

                case 0:
                    menCatalogDetailsVC.searchProductCategory = "Men Jacket"
                case 1:
                    menCatalogDetailsVC.searchProductCategory = "Men Pants"
                case 2:
                    menCatalogDetailsVC.searchProductCategory = "Men Shirts"
                case 3:
                    menCatalogDetailsVC.searchProductCategory = "Men T-Shirt"
                case 4:
                    menCatalogDetailsVC.searchProductCategory = "Men Coats"
                case 5:
                    menCatalogDetailsVC.searchProductCategory = "Men Suits"
                case 6:
                    menCatalogDetailsVC.searchProductCategory = "Men Sweaters"
                case 7:
                    menCatalogDetailsVC.searchProductCategory = "Men Dress Shoes"
                case 8:
                    menCatalogDetailsVC.searchProductCategory = "Men Tennis Shoes"
                case 9:
                    menCatalogDetailsVC.searchProductCategory = "Men Underwear"
                case 10:
                    menCatalogDetailsVC.searchProductCategory = "Men Casual Wear"
                default:
                    print("ERROR: No catalog selected selected")
                }
            }
        }
    }
}
