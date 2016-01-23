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
    
    var catalog = [Item]()
    
    var clickedCell = CatalogCell()
    
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
        
        amazonDada.searchProducts("African Dress")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath) as? CatalogCell {
            
            cell.itemLbl.text = self.amazonDada.amazonProducts[indexPath.row].title
            
            if let urlString = self.amazonDada.amazonProducts[indexPath.row].smallImage {

                if let url = NSURL(string: urlString) {

                    downloadImage(url, cell: cell)
                }
                
            }
 
  //          let item = catalog[indexPath.row]
  //          cell.configureCell(item)
            
            
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
            }
            
            
            return cell
            
        } else {
            
            return CatalogCell()
        }
        
        
//        cell.tilteLabel.text = self.amazonDada.amazonProducts[indexPath.row].title
//        cell.productGroupLabel.text = self.amazonDada.amazonProducts[indexPath.row].productGroup
//        cell.priceLabel.text = self.amazonDada.amazonProducts[indexPath.row].price
//        cell.asinLabel.text = self.amazonDada.amazonProducts[indexPath.row].asin
//        cell.brandLabel.text = self.amazonDada.amazonProducts[indexPath.row].brand
//        
//        
//        if let urlString = self.amazonDada.amazonProducts[indexPath.row].smallImage {
//            let url = NSURL(string: urlString)
//            cell.smallImage.hnk_setImageFromURL(url!)
//        }
//        else {
//            cell.smallImage.image = nil
//        }
//        
//        
//        return cell

    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, cell: CatalogCell){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                
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
        
        return CGSizeMake(450, 541)
        
    }
    
    func finishDownload() {
        self.collectionView.reloadData()
        
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        let catalogDetails = segue.destinationViewController as! CatalogDetailsView
//        
//        if let title = clickedCell.itemLbl.text {
//            
//            cell.itemLbl.text = self.amazonDada.amazonProducts[indexPath.row].title
//            
//            if let urlString = self.amazonDada.amazonProducts[indexPath.row].smallImage {
//        }
//    }
}
