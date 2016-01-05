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
        lType.text          = type
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
                    players.addObject(self.currentUser.username!)
                    game["players"] = players
                    let total = self.number + 1
                    game["num_players"] = total
                    if (total >= 10)
                    {
                        game["full"] = true
                    }
                    game.saveInBackground()
                }
                let alertController = UIAlertController(
                    title: "You have Joined the Game",
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
            else
            {
                print(error)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
