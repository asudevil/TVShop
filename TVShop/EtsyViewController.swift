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
    
    var clickedCell = CatalogCell()
    var catalog = [Item]()
    var selectedCell = [CatalogCell]()
    
    var selectedIndex = Int()
    
    let URL_BASE = "https://openapi.etsy.com/v2/listings/active?"
    let limit1 = 50
    let offset1 = 50

    
    let ETSY_KEY = "gzz1i25ohi2weccyfgb5kc08"
    
    var counter = 0
    
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        activityIndicator.startAnimating()
        
        downloadData()
        
//        activityIndicator.stopAnimating()
        
    }
    
    func downloadData() {
        
        //NOTE: All this should be in a seperate class for download manager class
        
        let urlString = "\(URL_BASE)limit=\(limit1)&offset=\(offset1)&includes=Images:1:0&api_key=\(ETSY_KEY)"
        
        counter = counter++
        
        print(counter)
        
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
            
            performSegueWithIdentifier("itemDetails", sender: self)
            
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
        
        let itemDetails = segue.destinationViewController as! ItemDetailsView
        
        if let title = clickedCell.itemLbl.text {
            itemDetails.clickedItemTitle = title
        }
        
        if let image = clickedCell.itemImg.image {
            itemDetails.clickedImage = image
            itemDetails.clickedSideImage1 = image
            itemDetails.clickedSideImage2 = image
            itemDetails.clickedSideImage3 = image
        }
        itemDetails.clickedBrand = clickedCell.itemBrand
        itemDetails.clickedPrice = clickedCell.itemPrice
        itemDetails.clickedItemCategory = clickedCell.itemDesc
        
    }
    
    
}
