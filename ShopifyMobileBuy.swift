//
//  ShopifyMobileBuy.swift
//  TVShop
//
//  Created by admin on 1/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation
import UIKit
import Buy

class ShopifyMobileBuy: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var collection: BUYCollection!
    
    let shopDomain = "shoptav.myshopify.com"
    let apiKey = "7226fcd904f430972ee4f6d87a08d4a8"
    let channelId = "42928961"
    let productId = "4009702273"

//    let shopDomain = "yoganinja.myshopify.com"
//    let apiKey = "706f85f7989134d8225e2ec4da7335b8"
//    let channelId = "49743622"
//    let productId = "5609902598"
//    
    
    
    var productVariant: BUYProductVariant?
    let client: BUYClient
    
    required init(coder aDecoder: NSCoder) {
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, channelId: channelId)
        super.init(coder: aDecoder)!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client.getProductById(productId) { (product, error) -> Void in
            self.titleLabel.text = product.title
            
            if let variants = product.variants as? [BUYProductVariant] {
                self.productVariant = variants.first
            }
            
            if (product != nil && error == nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    let images = product.images as NSArray
                    let buyImage = images.firstObject as! BUYImage
                    let url = NSURL(string: buyImage.src!)
                    
                    let data = NSData(contentsOfURL: url!)
                    let image = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func didTapCheckout(sender: UIButton) {
        
        // Create the checkout
        let cart = BUYCart()
        if let productVar = productVariant {
            cart.addVariant(productVar)
        }
        
        let checkout = BUYCheckout(cart: cart)
        client.createCheckout(checkout) { (checkout, error) -> Void in
            
            print("Checkout Clicked")
            
            let checkoutURL = checkout.webCheckoutURL
            
        //      if (UIApplication.sharedApplication().canOpenURL(checkoutURL)) {
                UIApplication.sharedApplication().openURL(checkoutURL)
                print("Checkout Open URL is \(checkoutURL)")
         //   }
        }
    }

}
