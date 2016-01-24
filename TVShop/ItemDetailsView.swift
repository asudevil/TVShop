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
    
    
    var clickedImage = UIImage()
    var clickedSideImage1 = UIImage()
    var clickedSideImage2 = UIImage()
    var clickedSideImage3 = UIImage()
    var clickedItemTitle = ""
    var clickedBrand = ""
    var clickedItemCategory = ""
    var clickedPrice = ""

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
