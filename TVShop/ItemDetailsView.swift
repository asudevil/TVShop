//
//  ItemDetailsView.swift
//  TVShop
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ItemDetailsView: UIViewController {
    
    @IBOutlet var sideImage1View: FocusView!
    @IBOutlet var sideImage2View: FocusView!
    @IBOutlet var sideImage3View: FocusView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var sideImage1: UIImageView!
    @IBOutlet var sideImage2: UIImageView!
    @IBOutlet var sideImage3: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var productCategory: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet weak var smLabel: UIButton!
    @IBOutlet weak var mdLabel: UIButton!
    @IBOutlet weak var lgLabel: UIButton!
    @IBOutlet weak var xlLabel: UIButton!
    @IBOutlet weak var qtyEntered: UITextField!
    
    @IBOutlet weak var cartQTYLabel: UILabel!
    
    var selectedSize = ""
    
    var clickedImage = UIImage()
    var clickedSideImage1 = UIImage()
    var clickedSideImage2 = UIImage()
    var clickedSideImage3 = UIImage()
    var clickedItemTitle = ""
    var clickedBrand = ""
    var clickedItemCategory = ""
    var clickedPrice = ""
    var clickedCell = CatalogCell()
    
    @IBAction func smButton(sender: AnyObject) {
        selectedSize = "small"
        smLabel.backgroundColor = UIColor.blackColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func mdButton(sender: AnyObject) {
        selectedSize = "medium"
        mdLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func lgButton(sender: AnyObject) {
        selectedSize = "large"
        lgLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func xlButton(sender: AnyObject) {
        selectedSize = "extraLarge"
        xlLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func addToCart(sender: AnyObject) {
        if selectedSize == "" {
            cartQTYLabel.text = "Please select a size."
        } else {
            
            if var cartQTY = qtyEntered.text {
                if cartQTY == "" || cartQTY == "0" {
                    cartQTY = "1"
                }
                
                let subtotal = Float(clickedPrice)! * Float(cartQTY)!
                cartQTYLabel.text = "QTY in your Cart \(cartQTY).  Subtotal = $\(subtotal)"
                
                
                let imagePath = clickedCell.imagePath
                
                let cell: [String: AnyObject] = ["image": imagePath, "title": clickedItemTitle, "price": clickedPrice, "brand": clickedBrand]
                
                let qty = Int(cartQTY)!
                let size = selectedSize
                
                
                let itemAttributes: [String: AnyObject] = ["cell": cell, "size": size, "qty": qty]
                
                if let returnedArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
                    
                    var arr = returnedArray as! [Dictionary<String, AnyObject>]
                    arr.append(itemAttributes)
                    NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "savedItems")
                    print("Array after saving $$$$$$$$$$$$$$ \(arr)")

                } else {
                    var newArray: [Dictionary<String, AnyObject>] = []
                    newArray.append(itemAttributes)
                    NSUserDefaults.standardUserDefaults().setObject(newArray, forKey: "savedItems")
                    let arr = NSUserDefaults.standardUserDefaults().objectForKey("savedItems")
                    print("New Array after saving $$$$$$$$$$$$$$ Printed!!! \(arr)")
                }


            } else {
                let cartQTY = 1
                let subtotal = Float(clickedPrice)! * Float(cartQTY)
                cartQTYLabel.text = "QTY in your Cart \(cartQTY).   Subtotal = $\(subtotal)"
            }
            
            
        }
    }
    @IBAction func clearCart(sender: AnyObject) {
        
        qtyEntered.text = "0"
        let subtotal = 0
        cartQTYLabel.text = "QTY in your Cart \(clickedCell.qtyInCart).   Subtotal = $\(subtotal)"
        NSUserDefaults.standardUserDefaults().removeObjectForKey("savedItems")
    }
    
    
    @IBAction func checkout(sender: AnyObject) {
        if selectedSize == "" {
            cartQTYLabel.text = "Please select a size."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = clickedImage
        sideImage1.image = clickedSideImage1
        sideImage2.image = clickedSideImage2
        sideImage3.image = clickedSideImage3
        itemTitle.text = clickedItemTitle
        brand.text = clickedBrand
        productCategory.text = clickedItemCategory
        price.text = clickedPrice
        
        cartQTYLabel.text = "QTY in your Cart \(clickedCell.qtyInCart)."
        
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if sideImage1View.focused == true {
            image.image = clickedSideImage1
        }
        
        if sideImage2View.focused == true {
            image.image = clickedSideImage2
        }
        
        if sideImage3View.focused == true {
            image.image = clickedSideImage3
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let checkoutView = segue.destinationViewController as? CheckoutVC {
         
            checkoutView.checkoutSKUId = clickedCell.itemSKUId
            checkoutView.checkoutCell = clickedCell
        }
    }
}
