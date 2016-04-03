//
//  CheckoutVC.swift
//  TVShop
//
//  Created by admin on 2/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBAction func clearList(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("savedItems")
        
        self.collectionView.reloadData()
        subtotalLabel.text = "0.00"
  //      shippingLabel.text = "0.00"
        totalCostLabel.text = "0.00"
        
    }
    var selectedIndex = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        calculateTotal()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.collectionView.reloadData()
        calculateTotal()
    }
    
//    func showAlert(status: String, title:String) {
//        let alertController = UIAlertController(title: status, message: title, preferredStyle: .Alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//        }
//        alertController.addAction(cancelAction)
//        
//        let ok = UIAlertAction(title: "OK", style: .Default) { (action) in
//        }
//        alertController.addAction(ok)
//        
//        self.presentViewController(alertController, animated: true) {
//        }
//    }
    
    func calculateTotal() {
        
        if let cartArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            let arr = cartArray as! [Dictionary<String, AnyObject>]
            
            var subtotalCost = 0.00
            var shipping = 0.00
            var totalCost = 0.00
            
            for output in arr {
                
                var sumQty = 0
                var cost = 0.00
                var cellCost = 0.00
                
                if let qty = output["qty"] as? Int {
                    sumQty = qty
                }
                
                if let size = output["cell"] as? [String: AnyObject] {
                    if let price = size["price"] as? String {
                        cost = Double(price)!
                    }
                }
                cellCost = Double(sumQty) * cost
                subtotalCost = subtotalCost + cellCost
                totalCost = subtotalCost - shipping
                subtotalLabel.text = "\(subtotalCost)0"
                totalCostLabel.text = "\(totalCost)0"
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("checkoutCell", forIndexPath: indexPath) as? ShoppingCartCell {
                        
            cell.setCell(indexPath.row)
            
        return cell
        } else {
            return ShoppingCartCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let returnedArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            let arr = returnedArray as! [Dictionary<String, AnyObject>]
            return arr.count
        } else {
            return 0
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.item
        
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
