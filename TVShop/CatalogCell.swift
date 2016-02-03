//
//  CatalogCell.swift
//  TVShop
//
//  Created by admin on 1/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CatalogCell: UICollectionViewCell {
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemLbl: UILabel!
    
    var itemDesc = ""
    var itemBrand = ""
    var itemPrice = ""
    var selectedIndex = Int()
    
    var setSideImage = UIImage()
    
    func configureCell(item: Item) {

        if let title = item.title {
            itemLbl.text = title
        }
        
        if let image = item.itemImagePath {
            
            if let urlNS = NSURL(string: image) {
                
                self.getDataFromUrl(urlNS) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        
                        if let downloadedImage = UIImage(data: data){
                            
                            self.itemImg.image = downloadedImage
                            self.setSideImage = downloadedImage
                        }
                    }
                }

            }
            
            
            itemImg.image = UIImage(named: image)
        }
        
        if let sideImage = item.sideImagePath {
            if let theImage = UIImage(named: sideImage) {
                setSideImage = theImage
            }
            
        }
        
        if let itemText = item.itemDescription {
            itemDesc = itemText
        }
        
        if let itemPrice1 = item.price {
            itemPrice = itemPrice1
        }
        
        selectedIndex = item.selectedCell
        
    }
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

}