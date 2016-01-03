//
//  item.swift
//  TVShop
//
//  Created by admin on 1/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation

class Item {
    
    let URL_BASE = "dress"

    var title: String!
    var itemDescription: String!
    var itemImagePath: String!
    
    init(itemDict: [String: AnyObject]) {
        
        if let title = itemDict["title"] as? String {
            self.title = title
        }
        
        if let description = itemDict["overview"] as? String {
            self.itemDescription = description
        }
        
        
        print("ImageCount is \(itemDict["image_path"])")
        
        if let imageCount = itemDict["image_path"] as? String {
            
            self.itemImagePath = "\(URL_BASE)\(imageCount).jpg"

        }
    }
    

}