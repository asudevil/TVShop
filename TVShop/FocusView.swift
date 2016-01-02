//
//  FocusView.swift
//  TVShop
//
//  Created by admin on 12/31/15.
//  Copyright © 2015 CodeWithFelix. All rights reserved.
//

import UIKit

class FocusView: UIView {
    
    var clicked = false

    override func canBecomeFocused() -> Bool {
        return true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
//        
//        if clicked == true {
//            
//            if context.previouslyFocusedView === self {
//                
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    context.previouslyFocusedView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
//                })
//            }
//            
//            if context.nextFocusedView === self {
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
//                })
//           }
//
//            print("Clicked image = true")
//        } else {
//           print("Clicked image = false")
//            
//        }
    }

}
