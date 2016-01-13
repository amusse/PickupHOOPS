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
    var currentUser: PFUser!    // The current user
    @IBOutlet weak var nbRating: UINavigationBar!
    @IBOutlet weak var lRating: UILabel!
    
    var rating = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        nbRating.topItem?.title = "Rating"
        nbRating.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!]
        rating = self.currentUser["rating"] as! Int
        lRating.text = String(rating)
    }
    
    // Update rating
    override func viewDidAppear(animated: Bool)
    {
        rating = self.currentUser["rating"] as! Int
        lRating.text = String(rating)
    }
}
