//
//  HomeViewController.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/5/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

// This class is a navigation controller that depends on the CarbonTabSwipeNavigation class.
// It controls the movement of view controllers and the tabs
class HomeViewController: UIViewController, CarbonTabSwipeNavigationDelegate
{

    var items = NSArray()               // Array of icons in navigation bar
    var currentUser: PFUser!            // The current user

    // The navigation bar
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        self.title = "Pickup Hoops"
        items = [UIImage(named: "home")!, UIImage(named: "Stadium-24")!, UIImage(named:"Trophy-25")!, UIImage(named: "Contacts-25")!]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insertIntoRootViewController(self)
        self.style()
    }

    
    // After pressing the logout button, the user signs out and we segue to the
    // log in screen
    @IBAction func btnLogout(sender: AnyObject)
    {
        PFUser.logOut()
        currentUser = PFUser.currentUser() // this will now be nil
        self.performSegueWithIdentifier("toLogoutVC", sender: self)
    }
    
    // Styles the navigation bar
    func style()
    {
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController!.navigationBar.barStyle = .BlackTranslucent
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        carbonTabSwipeNavigation.toolbar.translucent = false
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.blackColor())
        carbonTabSwipeNavigation.setTabExtraWidth(15)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(90, forSegmentAtIndex: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(90, forSegmentAtIndex: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(90, forSegmentAtIndex: 2)
        carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.blackColor(), font: UIFont.boldSystemFontOfSize(14))

    }
    
    // Switches between views
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController
    {
        switch index
        {
        case 0:
            return self.storyboard!.instantiateViewControllerWithIdentifier("HomeScreenVC") as! HomeScreenVC
        case 1:
            return self.storyboard!.instantiateViewControllerWithIdentifier("GamesVC") as! GamesVC
        case 2:
            return self.storyboard!.instantiateViewControllerWithIdentifier("RatingVC") as! RatingVC
        default:
            return self.storyboard!.instantiateViewControllerWithIdentifier("FriendsVC") as! FriendsVC
        }
    }
    
    // Output the current view controller index
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt)
    {
        var screen = ""
        if (index == 0)
        {
            screen = "Past Games Screen"
        }
        else if (index == 1)
        {
            screen = "Current Games Screen"
        }
        else if (index == 2)
        {
            screen = "Rating Screen"
        }
        else if (index == 3)
        {
            screen = "Friends Screen"
        }
        
        print("Did move at index: " + screen)
    }
    
}
