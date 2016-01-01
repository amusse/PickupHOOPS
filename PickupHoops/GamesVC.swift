//
//  GamesVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/31/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class GamesVC: UIViewController
{
    var currentUser = PFUser.currentUser()      // The current user
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnAdd(sender: AnyObject)
    {
        // Pop up sceen to add new game
        self.performSegueWithIdentifier("toNewGameVC", sender: self)
    }
}