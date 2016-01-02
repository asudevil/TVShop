//
//  ViewController.swift
//  TVShop
//
//  Created by admin on 11/18/15.
//  Copyright © 2015 CodeWithFelix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sideImage1: UIImageView!
    @IBOutlet weak var sideImage2: UIImageView!
    @IBOutlet weak var sideImage3: UIImageView!
    
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet weak var image: UIImageView!
    
    var swipCount = 0
    
    var clickedSideImage1 = UIImage()
    var clickedSideImage2 = UIImage()
    var clickedSideImage3 = UIImage()
    var clickedImage = UIImage()
    var clickedDescription = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideImage1.image = clickedSideImage1
        sideImage2.image = clickedSideImage2
        sideImage3.image = clickedSideImage3
        image.image = clickedImage
        descriptionLabel.text = clickedDescription
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipedResponse:"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedResponse:"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    func swipedResponse(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                swipCount++
                print("Swiped right")
                print(swipCount)
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                print(swipCount)
                swipCount--
            default:
                break
            }
            
        }
        
        if swipCount > 30 {
            swipCount = 0
        } else if swipCount < 0 {
            swipCount = 30
        }
        
        let imageValue = "dress\(swipCount).jpg"
        image.image = UIImage(named: imageValue)
        
        sideImage1.image = image.image
        sideImage2.image = image.image
        sideImage3.image = image.image
        
        print("Changed Image!!!!!!!")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

