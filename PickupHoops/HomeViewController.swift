//
//  HomeViewController.swift
//  Carbon Kit Swift
//
//  Created by Melies Kubrick on 10/12/15.
//  Copyright (c) 2015 Melies Kubrick. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, CarbonTabSwipeNavigationDelegate {

    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var currentUser = PFUser.currentUser()      // The current user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        self.title = "Pickup Hoops"
        items = [UIImage(named: "home")!, UIImage(named: "Stadium-24")!, UIImage(named: "Contacts-25")!, UIImage(named:"Trophy-25")!, UIImage(named:"Facebook-25")!, UIImage(named:"Twitter-25")!, UIImage(named:"Calendar 1-25")!, UIImage(named:"Search-25")!]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insertIntoRootViewController(self)
        self.style()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // After pressing the logout button, the user signs out and we segue to the
    // log in screen
    @IBAction func btnLogout(sender: AnyObject)
    {
        PFUser.logOut()
        currentUser = PFUser.currentUser() // this will now be nil
        self.performSegueWithIdentifier("toLogoutVC", sender: self)
    }
    
    func style()
    {
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
            //UIColor(red: 222/255, green: 112/255, blue: 22/255, alpha: 1)
        self.navigationController!.navigationBar.barStyle = .BlackTranslucent
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        carbonTabSwipeNavigation.toolbar.translucent = false
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.blackColor())
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 2)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.blackColor(), font: UIFont.boldSystemFontOfSize(14))

    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            return self.storyboard!.instantiateViewControllerWithIdentifier("ViewControllerOne") as! ViewControllerOne
        case 1:
            return self.storyboard!.instantiateViewControllerWithIdentifier("ViewControllerTwo") as! ViewControllerTwo
        default:
            return self.storyboard!.instantiateViewControllerWithIdentifier("ViewControllerThree") as! ViewControllerThree
        }
        
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        NSLog("Did move at index: %ld", index)
    }
    
}
