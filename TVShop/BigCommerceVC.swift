//
//  BigCommerceVC.swift
//  TVShop
//
//  Created by admin on 2/27/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class BigCommerceVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var catalog = [Item]()
    var selectedCell = [CatalogCell]()
    
    var selectedIndex = Int()
    
    let username = "YogaNinja"
    let API_key = "20996e0eb9b2b2cdae85cdca734d6cd2c49536db"
    let urlPath: String = "https://store-pkssh7z.mybigcommerce.com/api/v2/products.json?"
    
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
        
        let PasswordString = "\(username):\(API_key)"
        if let PasswordData = PasswordString.dataUsingEncoding(NSUTF8StringEncoding) {
            
            let base64EncodedCredential = PasswordData.base64EncodedStringWithOptions([])
            if let url: NSURL = NSURL(string: urlPath) {
                
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let authString = "Basic \(base64EncodedCredential)"
                config.HTTPAdditionalHeaders = ["Authorization" : authString]
                let session = NSURLSession(configuration: config)
                
                session.dataTaskWithURL(url) {
                    (let data, let response, let error) in
                    
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        
                        do {
                            let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            print(jsonResult)
                            
                            for obj in jsonResult {
                                if let objOutput = obj as? [String: AnyObject] {
                                    let item = Item(itemDict: objOutput, type: "women")
                                    self.catalog.append(item)
                                }
                            }
                            //                            Main UI thread
                            dispatch_async(dispatch_get_main_queue()) {
                                self.collectionView.reloadData()
                            }
                        } catch {
                            print("Catch jsonResult error: \(error)")
                            
                        }
                    }
                    }.resume()
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath) as? CatalogCell {
            
            let item = catalog[indexPath.row]
            item.selectedCell = indexPath.row
            cell.configureCell(item)
            
            self.activityIndicator.stopAnimating()
            
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
            
            //           performSegueWithIdentifier("itemDetails", sender: self)
            performSegueWithIdentifier("bigCommerceDetails", sender: cell)
            
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
                itemDetailsVC.clickedBrand = "Yoga Ninja"
                itemDetailsVC.clickedPrice = theCell.itemPrice
                itemDetailsVC.clickedItemCategory = theCell.itemDesc
                itemDetailsVC.clickedCell = theCell
                
            }
        }
    }
    
    
}

