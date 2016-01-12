//
//  PopUpVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/5/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class PopUpVC: UIViewController
{
    var currentUser :PFUser!
    var team = ""
    var gameId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
    }
    
    @IBAction func btnWon(sender: AnyObject)
    {
        let query = PFQuery(className: "Games")
        query.whereKey("objectId", equalTo: gameId)
        query.findObjectsInBackgroundWithBlock
        {
                (games:[PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    //found objects
                    for game in games!
                    {
                        if (self.team == "Team A")
                        {
                            var wins = (game["winsA"] as! Int)
                            wins++
                            game["winsA"] = wins
                        }
                        else
                        {
                            var wins = (game["winsB"] as! Int)
                            wins++
                            game["winsB"] = wins
                        }
                        game.saveInBackground()
                        if (game["winsA"] as! Int > game["winsB"] as! Int)
                        {
                            game["winner"] = "Team A"
                        }
                        else if ((game["winsA"] as! Int) < (game["winsB"] as! Int))
                        {
                            game["winner"] = "Team B"
                        }
                        else
                        {
                            game["winner"] = "Tie"
                        }
                        print(game["winner"] as! String)
                        game.saveInBackground()
                    }
                    
                    
                }
                else
                {
                    print(error)
                }
        

        }
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func btnLost(sender: AnyObject)
    {
        let query = PFQuery(className: "Games")
        query.whereKey("objectId", equalTo: gameId)
        query.findObjectsInBackgroundWithBlock
            {
                (games:[PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    //found objects
                    for game in games!
                    {
                        if (self.team == "Team A")
                        {
                            var wins = (game["winsB"] as! Int)
                            wins++
                            game["winsB"] = wins
                        }
                        else
                        {
                            var wins = (game["winsA"] as! Int)
                            wins++
                            game["winsA"] = wins
                        }
                        game.saveInBackground()
                        if (game["winsA"] as! Int > game["winsB"] as! Int)
                        {
                            game["winner"] = "Team A"
                        }
                        else if ((game["winsA"] as! Int) < (game["winsB"] as! Int))
                        {
                            game["winner"] = "Team B"
                        }
                        else
                        {
                            game["winner"] = "Tie"
                        }
                        print(game["winner"] as! String)
                        game.saveInBackground()
                    }
                }
                else
                {
                    print(error)
                }
                
                
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
