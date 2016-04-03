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
    var sideImagePath: String!
    var price: String!
    var id: String!
    
    var selectedCell = Int()
    
    
    init(itemDict: [String: AnyObject], type: String) {
        
        if let title = itemDict["title"] as? String {
            self.title = title
        }
        
        if let descriptionOutput = itemDict["description"] as? String {
            let theString = NSString(string: descriptionOutput)
            
            if theString.containsString("&nbsp") {
                let trimString = theString.substringWithRange(NSRange(location: 3, length: theString.length - 13))
                self.itemDescription = trimString as String
            }
            else if theString.containsString("<p>") {
                let trimString = theString.substringWithRange(NSRange(location: 3, length: theString.length - 7))
                self.itemDescription = trimString as String
            }
        }
        
        if let imageCount = itemDict["image_path"] as? String {
            self.itemImagePath = "\(type)\(imageCount).jpg"
        }
        
        if let priceOutput = itemDict["price"] as? String {
            self.price = priceOutput
        }
        
        if let imageEtsy = itemDict["Images"] as? [Dictionary<String, AnyObject>] {
            let displayImage = imageEtsy[0]
            if let etsyURL = displayImage["url_170x135"] as? String {
                self.itemImagePath = etsyURL
            }
        }
        
        if let imageShopify = itemDict["image"] as? Dictionary<String, AnyObject> {
            
            if let src = imageShopify["src"] as? String {
                self.itemImagePath = src
            }
            
        }
        
        if let bigImage = itemDict["primary_image"] as? Dictionary<String, AnyObject> {
            if let bigURL = bigImage["standard_url"] as? String {
                self.itemImagePath = bigURL
            }
        }
        
        if let bigPrice = itemDict["calculated_price"] as? String {
            
            let theString = NSString(string: bigPrice)
            
            if theString.containsString(".0000") {
                let trimString = theString.substringWithRange(NSRange(location: 0, length: theString.length - 2))
                self.price = trimString as String
            }

        }
        if let bigTitle = itemDict["name"] as? String {
            self.title = bigTitle
        }
        
        if let id = itemDict["id"] as? Int {
            self.id = String(id)
        }
        if let variants = itemDict["variants"] as? [Dictionary<String, AnyObject>] {
            let selectVariant = variants[0]
                if let shopifyPrice = selectVariant["price"] as? String {
                self.price = shopifyPrice
                print(self.price)
            }
        }
        
//testing concept
        let sideImageCount = "5"
        self.sideImagePath = "\(type)\(sideImageCount).jpg"

    }
}