//
//  ViewControllerOne.swift
//  Carbon Kit Swift
//
//  Created by Melies Kubrick on 10/12/15.
//  Copyright (c) 2015 Melies Kubrick. All rights reserved.
//

import UIKit
import Parse

class PastGamesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refresh: CarbonSwipeRefresh = CarbonSwipeRefresh()
    var currentUser: PFUser!     // The current user

    var locations       = [String]()
    var startTimes      = [NSDate]()
    var endTimes        = [NSDate]()
    var numPlayers      = [Int]()
    var types           = [String]()
    var minRatings      = [Int]()
    var locationTitles  = [String]()
    var gameIDs         = [String]()
    var notes           = [String]()
    var teams           = [String]()
    var wins            = [String]()
    var avgRatings      = [Int]()
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

    func getGames()
    {
        let query = PFQuery(className: "Games")
        query.orderByAscending("end")
        query.whereKey("end", lessThan: NSDate())
        query.findObjectsInBackgroundWithBlock
        {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                var i = 0
                // If there was no error, we found some games
                for game in games!
                {
                    let players: NSMutableArray = game["players"] as! NSMutableArray
                    
                    // If the current user is in this game
                    if (players.containsObject(self.currentUser.username!))
                    {
                        // If a new game as finished, store its information
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
                            let teamA = game["teamA"] as! NSMutableArray
                            
                            // If the current user is in Team A, store that information
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
                            {
                                self.teams.append("Team B")
                                // If Team B won the game, record that in the wins array
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
                        }
                        else
                        {
                            // If user is on Team A
                            if (self.teams[i] == "Team A")
                            {
                                // If Team A is the winner of the game and wasn't before, increase rating
                                if (game["winner"] as! String == "Team A" && self.wins[i] != "W")
                                {
                                    self.wins[i] = "W"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating + 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Team B" && self.wins[i] != "L")
                                {
                                    self.wins[i] = "L"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating - 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "W")
                                {
                                    self.wins[i] = "Tie"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating - 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "L")
                                {
                                    self.wins[i] = "Tie"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating + 20
                                    self.currentUser["rating"] = rating
                                }
                            }
                            else
                            {
                                if (game["winner"] as! String == "Team B" && self.wins[i] != "W")
                                {
                                    self.wins[i] = "W"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating + 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Team A" && self.wins[i] != "L")
                                {
                                    self.wins[i] = "L"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating - 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "W")
                                {
                                    self.wins[i] = "Tie"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating - 20
                                    self.currentUser["rating"] = rating
                                }
                                else if (game["winner"] as! String == "Tie" && self.wins[i] == "L")
                                {
                                    self.wins[i] = "Tie"
                                    var rating = self.currentUser.objectForKey("rating") as! Int
                                    rating = rating + 20
                                    self.currentUser["rating"] = rating
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations.count
    }
    
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
        singleCell.lMinRating.text = avgRatings[indexPath.row].description
        singleCell.lTeam.text   = teams[indexPath.row]
        singleCell.lWL.text     = wins[indexPath.row]
        if (wins[indexPath.row] ==  "W")
        {
            singleCell.lWL.textColor = UIColor.greenColor()
            print("Green")
        }
        else if (wins[indexPath.row] ==  "L")
        {
            singleCell.lWL.textColor = UIColor.redColor()
            print("Red")
        }
        else
        {
            singleCell.lWL.textColor = UIColor.orangeColor()
            print("Orange")
        }
        return singleCell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        team = teams[indexPath.row]
        gameId = gameIDs[indexPath.row]
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showView", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showView"
        {
            let vc = segue.destinationViewController as! PopUpVC
            vc.team = team
            vc.gameId = gameId
            let controller = vc.popoverPresentationController
            
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

    func refresh(sender: AnyObject) {
        NSLog("REFRESH")
        self.getGames()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(500 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.endRefreshing()
        }
    }
    
    func endRefreshing() {
        refresh.endRefreshing()
    }

}
