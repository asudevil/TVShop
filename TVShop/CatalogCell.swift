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
    
    var itemDescript = ""
    
    var setSideImage = UIImage()
    
    func configureCell(item: Item) {

        if let title = item.title {
            itemLbl.text = title
        }
        
        if let image = item.itemImagePath {
            itemImg.image = UIImage(named: image)
        }
        
        if let sideImage = item.sideImagePath {
            if let theImage = UIImage(named: sideImage) {
                setSideImage = theImage
                
            }
            
        }
        
        if let itemText = item.itemDescription {
            itemDescript = itemText
        }
        
        
        
        
//        if let imagePath = item.itemImagePath {
//            let url = NSURL(string: imagePath)!
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                
//                let data = NSData(contentsOfURL: url)!
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    let img = UIImage(data: data)
//                    self.itemImg.image = img
//                }
//            }
//        }
    }
}
