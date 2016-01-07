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
    
    var rating = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        nbRating.topItem?.title = "Rating"
        nbRating.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!]
        getRating()
        lRating.text = String(rating)
    }
    
    func getRating()
    {
        let query : PFQuery = PFQuery(className: "_User")
        let username = currentUser?.username!
        
        query.whereKey("username", equalTo: username!)
        query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if (error == nil)
            {
                for user in users!
                {
                    self.rating = user["rating"] as! Int
                    print("From parse: " + String(user["rating"] as! Int))
                    print("From parse: " + String(user["first_name"] as! String))
                }
            }
            else
            {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        getRating()
        lRating.text = String(rating)
    }
}
