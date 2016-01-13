//
//  GamesVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/31/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

// This view contains the GamesTableVC
class GamesVC: UIViewController
{
    var currentUser = PFUser.currentUser()      // The current user
    
    @IBOutlet weak var nbCurrentGames: UINavigationBar!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nbCurrentGames.topItem?.title = "Current Games"
        nbCurrentGames.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!]
    }
    
    @IBAction func btnAdd(sender: AnyObject)
    {
        // Pop up sceen to add new game
        self.performSegueWithIdentifier("toNewGameVC", sender: self)
    }
}