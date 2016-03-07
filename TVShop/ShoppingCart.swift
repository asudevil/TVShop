//
//  ShoppingCart.swift
//  TVShop
//
//  Created by admin on 3/5/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation

class ShoppingCart {
    
     var selectedCell = CatalogCell()
     var selectedSize = String()
     var selectedQTY = Int()
    
    init (cell: CatalogCell, itemSize: String, qty: Int) {
        
        selectedCell = cell
        selectedSize = itemSize
        selectedQTY = qty
        
    }
    
}