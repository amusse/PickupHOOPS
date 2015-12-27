//
//  HomeVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class HomeVC: UIViewController
{
    @IBOutlet weak var lFirstName: UILabel!     // First name label
    var currentUser = PFUser.currentUser()      // The current user
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        lFirstName.text = currentUser!.objectForKey("first_name") as? String
    }

    // After pressing the logout button, the user signs out and we segue to the
    // log in screen
    @IBAction func btnLogout(sender: AnyObject)
    {
        PFUser.logOut()
        currentUser = PFUser.currentUser() // this will now be nil
        self.performSegueWithIdentifier("toLogoutVC", sender: self)
    }
}

