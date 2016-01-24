//
//  WomenAmazonView.swift
//  TVShop
//
//  Created by admin on 1/23/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class WomenAmazonView: UIViewController {
    
    @IBOutlet var firstImageView: FocusView!
    @IBOutlet var secondImageView: FocusView!
    @IBOutlet var thirdImageView: FocusView!
    @IBOutlet var fourthImageView: FocusView!
    @IBOutlet var fifthImageView: FocusView!
    @IBOutlet var sixthImageView: FocusView!
    @IBOutlet var seventhImageView: FocusView!
    @IBOutlet var eigthImageView: FocusView!
    
    
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet var thirdImage: UIImageView!
    @IBOutlet var forthImage: UIImageView!
    
    var tappedImage = FocusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureReconizer(firstImageView)
        gestureReconizer(secondImageView)
        gestureReconizer(thirdImageView)
        gestureReconizer(fourthImageView)
        gestureReconizer(fifthImageView)
        gestureReconizer(sixthImageView)
        gestureReconizer(seventhImageView)
        gestureReconizer(eigthImageView)
        
    }
    
    func gestureReconizer(imageView: FocusView) {
        
        if imageView.gestureRecognizers?.count == nil {
            let tap = UITapGestureRecognizer(target: self, action: "tapped:")
            tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
            imageView.addGestureRecognizer(tap)
            
        }
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let clickedImage = gesture.view as? FocusView {
            
            tappedImage = clickedImage
                        
            performSegueWithIdentifier("menCatalogDetails", sender: self)
            
            }
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let selectedCatalog = segue.destinationViewController as! AmazonViewController
        
        if firstImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "Women gown"
        }
        if secondImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "Women skirt"
        }
        if thirdImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "Women dress"
        }
        if fourthImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "Women shoes"
        }
        if fifthImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "African dress"
        }
        if sixthImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "African Children Clothes"
        }
        if seventhImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "African Clothes"
        }
        if eigthImageView.gestureRecognizers?.count != nil {
            selectedCatalog.searchProductCategory = "African dress"
        }
        
    }
    
    
}
