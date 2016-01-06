//
//  RatingVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/27/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class RatingVC: UIViewController
{
    var currentUser = PFUser.currentUser()      // The current user
    @IBOutlet weak var nbRating: UINavigationBar!
    @IBOutlet weak var lRating: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        nbRating.topItem?.title = "Rating"
        nbRating.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!]
        let rating = currentUser!.objectForKey("rating") as? Int
        lRating.text = String(rating!)
    }
    
}
