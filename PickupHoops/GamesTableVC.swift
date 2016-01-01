//
//  GamesVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/27/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class GamesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    var refresh: CarbonSwipeRefresh = CarbonSwipeRefresh()
    var currentUser: PFUser!     // The current user
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        refresh = CarbonSwipeRefresh(scrollView: self.tableView)
        refresh.setMarginTop(0)
        refresh.colors = [UIColor.blueColor(), UIColor.redColor(), UIColor.orangeColor(), UIColor.greenColor()]
        self.view.addSubview(refresh)
        refresh.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let firstname = currentUser!.objectForKey("first_name") as? String
        cell.textLabel!.text = firstname!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view: ViewControllerThree = self.storyboard!.instantiateViewControllerWithIdentifier("ViewControllerThree") as! ViewControllerThree
        self.navigationController!.pushViewController(view, animated: true)
    }
    
    func refresh(sender: AnyObject) {
        NSLog("REFRESH")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.endRefreshing()
        }
    }
    
    func endRefreshing() {
        refresh.endRefreshing()
    }
    
}
