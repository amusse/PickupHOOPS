//
//  HomeScreenVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/5/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

// This view hold the "PastGamesTableVC" in a container
class HomeScreenVC: UIViewController
{
    @IBOutlet weak var nbCurrentUser: UINavigationBar!
    
    @IBOutlet var lUser: UILabel!
    var firstName = "First Name"
    var currentUser: PFUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        
        lUser.text = currentUser!.objectForKey("first_name") as? String
        nbCurrentUser.topItem?.title = "Past Games"
        nbCurrentUser.titleTextAttributes =  [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!]
    }
}
