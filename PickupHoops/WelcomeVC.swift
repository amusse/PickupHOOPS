//
//  WelcomeVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class WelcomeVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // Pressing the log in button prompts user to login. If user is
    // already logged in, view transitions to home screen
    @IBAction func btnLogin(sender: AnyObject)
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            self.performSegueWithIdentifier("toHomeScreenVC", sender: self)
        }
        else
        {
            // Show the login screen
            self.performSegueWithIdentifier("toLoginScreenVC", sender: self)
        }
    }
    
}