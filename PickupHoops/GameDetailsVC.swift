//
//  GameDetailsVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class GameDetailsVC: UIViewController
{

    @IBOutlet weak var lLocation:       UILabel!
    @IBOutlet weak var lType:           UILabel!
    @IBOutlet weak var lMinRating:      UILabel!
    @IBOutlet weak var lCoordinates:    UILabel!
    @IBOutlet weak var lStartTime:      UILabel!
    @IBOutlet weak var lEndTime:        UILabel!
    @IBOutlet weak var lNumPlayers:     UILabel!
    
    @IBOutlet weak var tvNotes: UITextView!
    
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnFull: UIButton!
    
    var location:       String!
    var type:           String!
    var minRating:      String!
    var coordinates:    String!
    var start:          String!
    var end:            String!
    var numPlayer:     String!
    var note:          String!
    
    var currentUser:    PFUser!
    var gameID:         String!
    var number:         Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        
        tvNotes.layer.borderWidth = 0.1
        tvNotes.layer.cornerRadius = 10
        
        lLocation.text      = location
        lType.text          = ""
        lMinRating.text     = minRating
        lCoordinates.text   = coordinates
        lStartTime.text     = start
        lEndTime.text       = end
        lNumPlayers.text    = numPlayer
        tvNotes.text        = note
        
        number = Int(numPlayer)!
        if (number >= 10)
        {
            btnJoin.hidden = true
            btnFull.hidden = false
        }
        else
        {
            btnJoin.hidden = false
            btnFull.hidden = true
        }
    }

    func displayAlertJoined()
    {
        let alertController = UIAlertController(
            title: "You have joined the game",
            message: "Check the home screen when the game is full to see what team you are on",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { action in self.navigationController?.popViewControllerAnimated(true)}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func displayAlertDuplicate()
    {
        let alertController = UIAlertController(
            title: "Already joined the game",
            message: "Check the home screen when the game is over to see what team you were on and the result of the game",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { action in print("Already joined game.")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // Join game
    @IBAction func btnJoin(sender: AnyObject)
    {
        let query = PFQuery(className: "Games")
        query.whereKey("objectId", equalTo: gameID)
        query.findObjectsInBackgroundWithBlock
        {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                //found objects
                for game in games!
                {
                    let players: NSMutableArray = game["players"] as! NSMutableArray
                    if (!players.containsObject(self.currentUser.username!))
                    {
                        // Add the player to the game
                        players.addObject(self.currentUser.username!)
                        game["players"] = players
                        
                        // Increase the number of players
                        let total = self.number + 1
                        game["num_players"] = total
                        
                        let userRating = self.currentUser.objectForKey("rating") as! Int
                        let gamesPlayed = self.currentUser.objectForKey("gamesPlayed") as! Int
                        self.currentUser["gamesPlayed"] = gamesPlayed + 1
                        
                        // Add to the teams
                        let teamA = game["teamA"] as! NSMutableArray
                        let teamB = game["teamB"] as! NSMutableArray
                        if (teamA.count > teamB.count)
                        {
                            teamB.addObject(self.currentUser.username!)
                            game["teamB"] = teamB
                            game["teamBRating"] = game["teamBRating"] as! Int + userRating
                        }
                        else
                        {
                            teamA.addObject(self.currentUser.username!)
                            game["teamA"] = teamA
                            game["teamARating"] = game["teamARating"] as! Int + userRating
                        }
                        if (total >= 10)
                        {
                            game["full"] = true
                        }
                        
                        // Increase the average rating
                        let rating = game["avg_rating"] as! Int
                        let avgRating = Double(rating + userRating)/Double(total)
                        let newAvg: Int = Int(floor(avgRating))
                        game["avg_rating"] = newAvg
                        
                        game.saveInBackground()
                        self.displayAlertJoined()
                    }
                    else
                    {
                        self.displayAlertDuplicate()
                    }
                    
                }
                

            }
            else
            {
                print(error)
            }
        }
    }
}
