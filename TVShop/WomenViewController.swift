//
//  WomenViewController.swift
//  TVShop
//
//  Created by admin on 12/31/15.
//  Copyright © 2015 CodeWithFelix. All rights reserved.
//

import UIKit

class WomenViewController: UIViewController {

    @IBOutlet var firstImageView: FocusView!
    
    
    @IBOutlet var secondImageView: FocusView!
    
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet var thirdImage: UIImageView!
    @IBOutlet var forthImage: UIImageView!
    
    var tappedImage = FocusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstImageView.gestureRecognizers?.count == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(WomenViewController.tapped(_:)))
            tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
            firstImageView.addGestureRecognizer(tap)
            
        }
        if secondImageView.gestureRecognizers?.count == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(WomenViewController.tapped(_:)))
            tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
            secondImageView.addGestureRecognizer(tap)
        }
        
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let clickedImage = gesture.view as? FocusView {
            
           tappedImage = clickedImage
            
            print("You tapped on an item")
            
            performSegueWithIdentifier("catalog", sender: self)
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let selectedCatalog = segue.destinationViewController as? ViewController {
        
            if firstImageView.gestureRecognizers?.count != nil {
                
                if let assignImage = firstImage.image {
                    
                    selectedCatalog.clickedImage = assignImage
                    selectedCatalog.clickedSideImage1 = assignImage
                    selectedCatalog.clickedSideImage2 = assignImage
                    selectedCatalog.clickedSideImage3 = assignImage
                    
                }
            }
        }
    }
}
