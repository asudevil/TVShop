//
//  item.swift
//  TVShop
//
//  Created by admin on 1/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation

class Item {

    var title: String!
    var itemDescription: String!
    var itemImagePath: String!
    
    init(itemDict: [String: AnyObject], type: String) {
        
        if let title = itemDict["title"] as? String {
            self.title = title
        }
        
        if let description = itemDict["description"] as? String {
            self.itemDescription = description
        }
        
        if let imageCount = itemDict["image_path"] as? String {
            
            self.itemImagePath = "\(type)\(imageCount).jpg"

        }
    }
    

}