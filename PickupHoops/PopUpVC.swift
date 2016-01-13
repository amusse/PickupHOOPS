//
//  PopUpVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/5/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

// This view is a popup view that allows the user to input the result of a game
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
    
    // If user presses the "Won" button, record that the current user has won the game
    @IBAction func btnWon(sender: AnyObject)
    {
        let query = PFQuery(className: "Games")
        query.whereKey("objectId", equalTo: gameId)
        query.findObjectsInBackgroundWithBlock
        {
                (games:[PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
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
                        
                        // Wait for data to get saved
                        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                        dispatch_after(delayTime, dispatch_get_main_queue())
                        {
                        }
                        
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
                        game.saveInBackground()

                        // Wait for data to get saved
                        dispatch_after(delayTime, dispatch_get_main_queue())
                        {
                            
                        }
                        print(game["winner"] as! String)
                    }
                }
                else
                {
                    print(error)
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // If user presses the "Lost" button, record that the current user has lost the game
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
                        
                        // Wait for data to get saved
                        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                        dispatch_after(delayTime, dispatch_get_main_queue())
                            {
                        }

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
                        game.saveInBackground()
                        
                        // Wait for data to get saved
                        dispatch_after(delayTime, dispatch_get_main_queue())
                        {
                        }
                        
                        print(game["winner"] as! String)
                        
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
