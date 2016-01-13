//
//  PastGamesTableVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/5/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

// This view displays all of the previous games that the current user played in. It also allows
// the user to input the result of the game
class PastGamesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var refresh: CarbonSwipeRefresh = CarbonSwipeRefresh()
    
    var currentUser: PFUser!                // The current user

    // These properties pertain to each game a user played
    var locations       = [String]()        // Latitude and longitude coordinates of location
    var startTimes      = [NSDate]()        // Start times of each game
    var endTimes        = [NSDate]()        // End times of each game
    var numPlayers      = [Int]()           // Number of players in each game
    var types           = [String]()        // Whether or not the game is private or public
    var avgRatings      = [Int]()           // Average rating for each game
    var locationTitles  = [String]()        // The name of the location of the game
    var gameIDs         = [String]()        // The Parse objectIDs of each game
    var notes           = [String]()        // The notes for a specific game
    var teams           = [String]()        // The team the current user is on
    var wins            = [String]()        // Whether or not the user won a game
    
    // Data to pass to next view controller
    var team            = "Team A"
    var gameId          = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        refresh = CarbonSwipeRefresh(scrollView: self.tableView)
        getGames()
        refresh.setMarginTop(0)
        refresh.colors = [UIColor.blueColor(), UIColor.redColor(), UIColor.orangeColor(), UIColor.greenColor()]
        self.view.addSubview(refresh)
        refresh.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    // This function updates the rating for a user according to the Elo Rating System
    func updateRating(result: String, gamesPlayed: Int, teamAvg: Int)
    {
        // K is their gain factor according to the elo rating system
        var K = 32.0
        
        let rating = Double(self.currentUser.objectForKey("rating") as! Int)
        
        // If the user has played a small number of games, their rating should be volatile
        if (gamesPlayed < 10)
        {
            K = 64.0
        }
        else
        {
            K = 32.0
        }
        
        let playerGain = floor(((rating/Double(teamAvg)) / (1/5) * K))
        let change = Int(playerGain)
        
        if (result == "W")
        {
            // Increase player rating
            currentUser["rating"] = Int(rating) + change
        }
        if (result == "L")
        {
            // Decrease player rating
            currentUser["rating"] = Int(rating) - change
        }
        currentUser.saveInBackground()
    }

    // Updates all the properties for this class by retreiving a "Game" from Parse
    func getGames()
    {
        let query = PFQuery(className: "Games")
        query.orderByAscending("end")
        
        // Get games that already occurred
        query.whereKey("end", lessThan: NSDate())
        query.findObjectsInBackgroundWithBlock
        {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                var i = 0
                for game in games!
                {
                    let players: NSMutableArray = game["players"] as! NSMutableArray
                    
                    // If the current user is in this game
                    if (players.containsObject(self.currentUser.username!))
                    {
                        // If a new game has finished, add this game into our properties
                        if (!self.gameIDs.contains(game.objectId!))
                        {
                            // Gets the game location in latitude and longitude
                            let location = game["location"] as! (PFGeoPoint)
                            let combined = location.latitude.description + " " + location.longitude.description
                            
                            // Populate game data
                            self.gameIDs.append(game.objectId!)
                            self.locations.append(combined)
                            self.startTimes.append(game["start"] as! (NSDate))
                            self.endTimes.append(game["end"] as! (NSDate))
                            self.numPlayers.append(game["num_players"] as! (Int))
                            self.types.append(game["type"] as! (String))
                            self.avgRatings.append(game["avg_rating"] as! (Int))
                            self.locationTitles.append(game["locationTitle"] as! (String))
                            self.notes.append(game["notes"] as! (String))
                            
                            // If the current user is in Team A, store that information
                            let teamA = game["teamA"] as! NSMutableArray
                            if (teamA.containsObject(self.currentUser.username!))
                            {
                                self.teams.append("Team A")
                                
                                // If Team A won the game, record that in the wins array
                                if (game["winner"] as! String == "Team A")
                                {
                                    self.wins.append("W")
                                }
                                else if (game["winner"] as! String == "Team B")
                                {
                                    self.wins.append("L")
                                }
                                else
                                {
                                    self.wins.append("Tie")
                                }
                            }
                            else
                            {   // Otherwise the current user is in Team B, store its information
                                self.teams.append("Team B")
                                if (game["winner"] as! String == "Team B")
                                {
                                    self.wins.append("W")
                                }
                                else if (game["winner"] as! String == "Team A")
                                {
                                    self.wins.append("L")
                                }
                                else
                                {
                                    self.wins.append("Tie")
                                }
                            }
                            
                            // Calcualte average rating for each team
                            print(game["teamARating"] as! Int)
                            let averageRatingA = floor(Double((game["teamARating"] as! Int))/5)
                            game["teamARating"] = Int(averageRatingA)
                            let averageRatingB = floor(Double(game["teamBRating"] as! Int)/5)
                            game["teamBRating"] = Int(averageRatingB)
                            
                        }
                        else
                        {
                            let gamesPlayed = self.currentUser.objectForKey("gamesPlayed") as! Int
                            var teamAvg = 0
                            // If there is no new game, then just refresh our data
                            if (self.teams[i] == "Team A")
                            {
                                teamAvg = game["teamARating"] as! Int
                                
                                // If Team A is the winner of the game and wasn't before, increase rating
                                if (game["winner"] as! String == "Team A" && self.wins[i] != "W")
                                {
                                    self.wins[i] = "W"
                                    self.updateRating("W", gamesPlayed: gamesPlayed , teamAvg: teamAvg)
                                }
                                    
                                else if (game["winner"] as! String == "Team B" && self.wins[i] != "L")
                                {
                                    self.wins[i] = "L"
                                    self.updateRating("L", gamesPlayed: gamesPlayed , teamAvg: teamAvg)

                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "W")
                                {
                                    self.wins[i] = "Tie"
                                    self.updateRating("L", gamesPlayed: gamesPlayed , teamAvg: teamAvg)

                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "L")
                                {
                                    self.wins[i] = "Tie"
                                    self.updateRating("W", gamesPlayed: gamesPlayed , teamAvg: teamAvg)
                                }
                            }
                            else
                            {
                                teamAvg = game["teamBRating"] as! Int
                                if (game["winner"] as! String == "Team B" && self.wins[i] != "W")
                                {
                                    self.wins[i] = "W"
                                    self.updateRating("W", gamesPlayed: gamesPlayed , teamAvg: teamAvg)

                                }
                                else if (game["winner"] as! String == "Team A" && self.wins[i] != "L")
                                {
                                    self.wins[i] = "L"
                                    self.updateRating("L", gamesPlayed: gamesPlayed , teamAvg: teamAvg)

                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "W")
                                {
                                    self.wins[i] = "Tie"
                                    self.updateRating("W", gamesPlayed: gamesPlayed , teamAvg: teamAvg)

                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "L")
                                {
                                    self.wins[i] = "Tie"
                                    self.updateRating("W", gamesPlayed: gamesPlayed , teamAvg: teamAvg)
                                }
                            }
                            i++
                        }
                    }
                    self.currentUser.saveInBackground()
                }
                self.tableView.reloadData()
            }
            else
            {
                print(error)
            }
        }
    }

    // The number of rows in the tableView is equivalent ot the number of games played by the
    // current user
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations.count
    }
    
    // Update UI elements of each row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let singleCell: SingleRowCell = tableView.dequeueReusableCellWithIdentifier("cell") as! SingleRowCell
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: startTimes[indexPath.row])
        let hour = comp.hour
        let minute = comp.minute
        let time = hour.description + ":" + minute.description
        
        singleCell.lLocation.text = locationTitles[indexPath.row]
        singleCell.lStartTime.text = time
        singleCell.lNumPlayers.text = numPlayers[indexPath.row].description
        singleCell.lAvgRating.text = avgRatings[indexPath.row].description
        singleCell.lTeam.text   = teams[indexPath.row]
        singleCell.lWL.text     = wins[indexPath.row]
        if (wins[indexPath.row] ==  "W")
        {
            singleCell.lWL.textColor = UIColor.greenColor()
        }
        else if (wins[indexPath.row] ==  "L")
        {
            singleCell.lWL.textColor = UIColor.redColor()
        }
        else
        {
            singleCell.lWL.textColor = UIColor.orangeColor()
        }
        return singleCell
    }

    // Once a row is clicked, popup a view that allows a player to enter in the result of the
    // game
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        team = teams[indexPath.row]
        gameId = gameIDs[indexPath.row]
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showView", sender: self)
        }
    }
    
    // Pass data along to the popup view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showView"
        {
            let popup = segue.destinationViewController as! PopUpVC
            popup.team = team
            popup.gameId = gameId
            let controller = popup.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
                
            }
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }

    // When the tableView is swiped down, refresh the data in the cells
    func refresh(sender: AnyObject)
    {
        NSLog("REFRESH")
        self.getGames()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(500 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.endRefreshing()
        }
    }
    
    // Stop refreshing the data
    func endRefreshing()
    {
        refresh.endRefreshing()
    }

}
