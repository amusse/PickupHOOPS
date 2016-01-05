//
//  Test.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/4/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class Test: UIViewController
{
    override func viewDidLoad()
    {
        let query = PFQuery(className: "Games")
        query.orderByAscending("end")
        query.whereKey("end", greaterThan: NSDate())
        query.findObjectsInBackgroundWithBlock {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                //found objects
                for game in games!
                {
                    print(game.objectId)
                    print((game["end"] as! (NSDate)).description)
                }
            }
            else
            {
                print(error)
            }
        }

        
    }

}
