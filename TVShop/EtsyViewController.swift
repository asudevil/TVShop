//
//  EtsyViewController.swift
//  TVShop
//
//  Created by admin on 1/31/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class EtsyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var catalog = [Item]()
    var selectedIndex = Int()
    
    let URL_BASE = "https://openapi.etsy.com/v2/listings/active?"
    let limit1 = 50
    let offset1 = 0
    
    let ETSY_KEY = "gzz1i25ohi2weccyfgb5kc08"
    
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
        
        // https://openapi.etsy.com/v2/listings/active?limit=50&offset=1&includes=Images:1:0&api_key=gzz1i25ohi2weccyfgb5kc08
        
        let urlString = "\(URL_BASE)limit=\(limit1)&offset=\(offset1)&includes=Images:1:0&api_key=\(ETSY_KEY)"
        
        let url = NSURL(string: urlString)!
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
            
            let item = catalog[indexPath.row]
            item.selectedCell = indexPath.row
            cell.configureCell(item)
            
            self.activityIndicator.stopAnimating()
                        
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(EtsyViewController.tapped(_:)))
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
                        
 //           performSegueWithIdentifier("itemDetails", sender: self)
            performSegueWithIdentifier("itemDetails", sender: cell)
            
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, cell: CatalogCell){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                
                if let downloadedImage = UIImage(data: data){
                    
                    cell.itemImg.image = downloadedImage
                    cell.setSideImage = downloadedImage
                }
            }
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
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
      //  if let segue.identifier == "itemDetails" {
            
            if let itemDetailsVC = segue.destinationViewController as? ItemDetailsView {
                
                if let theCell = sender as? CatalogCell {
                    
                    if let title = theCell.itemLbl.text {
                        itemDetailsVC.clickedItemTitle = title
                        
                    }
                    if let image = theCell.itemImg.image {
                        itemDetailsVC.clickedImage = image
                        itemDetailsVC.clickedSideImage1 = image
                        itemDetailsVC.clickedSideImage2 = image
                        itemDetailsVC.clickedSideImage3 = image
                        
                    }
                    itemDetailsVC.clickedBrand = theCell.itemBrand
                    itemDetailsVC.clickedPrice = theCell.itemPrice
                    itemDetailsVC.clickedItemCategory = theCell.itemDesc
                    itemDetailsVC.clickedProductId = theCell.itemProductId

                }
            }
      //  }
        
    }
    
    
}
