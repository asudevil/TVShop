//
//  AmazonViewController.swift
//  TVShop
//
//  Created by admin on 1/23/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class AmazonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DownloadFinishProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var catalog = [Item]()
    
    var clickedCell = CatalogCell()
    
    var searchProductCategory = "African Dress"
    
    let amazonDada = AmazonData(
        key: "AKIAJXBD6OLZXTNY4USQ",
        secret: "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",
        associate: "shoptav-20",
        countPages: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        amazonDada.delegate = self
        
        //start activity indicator spinner
        activityIndicator.startAnimating()
        
        amazonDada.searchProducts(searchProductCategory)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath) as? CatalogCell {
            
            if let title = self.amazonDada.amazonProducts[indexPath.row].title {
                cell.itemLbl.text = title
                
        //stop activity indicator spinner
                activityIndicator.stopAnimating()
            }
            
            if let brand = self.amazonDada.amazonProducts[indexPath.row].brand {
                cell.itemBrand = brand
            }
            
            if let price = self.amazonDada.amazonProducts[indexPath.row].price {
                cell.itemPrice = price
            }
            
            if let product = self.amazonDada.amazonProducts[indexPath.row].productGroup {
                cell.itemDesc = product
            }
            
            if let urlString = self.amazonDada.amazonProducts[indexPath.row].smallImage {
                if let url = NSURL(string: urlString) {
                    downloadImage(url, cell: cell)
                }
                
            }
            
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
        return self.amazonDada.amazonProducts.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(630, 830)
        
    }
    
    func finishDownload() {
        self.collectionView.reloadData()
        
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
