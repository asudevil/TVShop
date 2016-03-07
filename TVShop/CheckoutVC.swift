//
//  CheckoutVC.swift
//  TVShop
//
//  Created by admin on 2/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController, UITableViewDelegate {
    
    
//    @IBOutlet weak var checkoutTitle: UILabel!
//    @IBOutlet weak var checkoutSKULabel: UILabel!
//    @IBOutlet weak var checkoutPriceLabel: UILabel!
    
    var checkoutCell = CatalogCell()
    var checkoutSKUId = ""
    
    var cartItems = ["Yoga Ninja Item 1:  Comfort style.  Option:  White / Medium Qty:  1    Price:  $25",
        "Yoga Ninja Item 2:  Comfort style.  Option:  White / Medium  Qty:  1    Price:  $25",
        "Yoga Ninja Item 3:  Comfort style.   Option:  White / Medium  Qty:  10    Price:  $35",
        "Yoga Ninja Item 4:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 5:  Comfort style.  Loose fit flowing tank, combines with a dash of awesome! ",
        "Yoga Ninja Item 6:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 7:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 8:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 9:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 10:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 11:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 12:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 13:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25",
        "Yoga Ninja Item 14:  Comfort style.  Option:  White / Medium  Qty:  6    Price:  $25"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
  //      checkoutSKULabel.text = checkoutSKUId
  //      checkoutPriceLabel.text = checkoutCell.itemPrice
  //      checkoutTitle.text = checkoutCell.itemLbl.text

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cartItems[indexPath.row]
        
        return cell
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
