//
//  ProfileVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/27/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class FriendsVC: UIViewController
{
    var currentUser = PFUser.currentUser()      // The current user
    
    @IBOutlet weak var scFriends: UISegmentedControl!
    @IBOutlet weak var nbFriends: UINavigationBar!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        let subViewOfSegment: UIView = scFriends.subviews[0] as UIView
        subViewOfSegment.tintColor = UIColor.blackColor()
    }
    
}
