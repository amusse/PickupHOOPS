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
        query.findObjectsInBackgroundWithBlock {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                //found objects
                var i = 0
                for game in games!
                {
                    let players: NSMutableArray = game["players"] as! NSMutableArray
                    print(players)
                    if (players.containsObject(self.currentUser.username!))
                    {
                        if (!self.gameIDs.contains(game.objectId!))
                        {
                            let location = game["location"] as! (PFGeoPoint)
                            let combined = location.latitude.description + " " + location.longitude.description
                            self.gameIDs.append(game.objectId!)
                            self.locations.append(combined)
                            self.startTimes.append(game["start"] as! (NSDate))
                            self.endTimes.append(game["end"] as! (NSDate))
                            self.numPlayers.append(game["num_players"] as! (Int))
                            self.types.append(game["type"] as! (String))
                            self.minRatings.append(game["min_rating"] as! (Int))
                            self.locationTitles.append(game["locationTitle"] as! (String))
                            self.notes.append(game["notes"] as! (String))
                            let teamA = game["teamA"] as! NSMutableArray
                            if (teamA.containsObject(self.currentUser.username!))
                            {
                                self.teams.append("Team A")
                            }
                            else
                            {
                                self.teams.append("Team B")
                            }
                            if (self.teams[i] == "Team A")
                            {
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
                            
                            //print(game)
                        }
                        else
                        {
                            let location = game["location"] as! (PFGeoPoint)
                            let combined = location.latitude.description + " " + location.longitude.description
                            self.gameIDs[i] = game.objectId!
                            self.locations[i] = combined
                            self.startTimes[i] = (game["start"] as! (NSDate))
                            self.endTimes[i] = (game["end"] as! (NSDate))
                            self.numPlayers[i] = (game["num_players"] as! (Int))
                            self.types[i] = (game["type"] as! (String))
                            self.minRatings[i] = (game["min_rating"] as! (Int))
                            self.locationTitles[i] = (game["locationTitle"] as! (String))
                            self.notes[i] = (game["notes"] as! (String))
                            if (self.teams[i] == "Team A")
                            {
                                if (game["winner"] as! String == "Team A")
                                {
                                    self.wins[i] = "W"
                                }
                                else if (game["winner"] as! String == "Team B")
                                {
                                    self.wins[i] = "L"
                                }
                                else
                                {
                                    self.wins[i] = "Tie"
                                }
                            }
                            else
                            {
                                if (game["winner"] as! String == "Team B")
                                {
                                    self.wins[i] = "W"
                                }
                                else if (game["winner"] as! String == "Team A")
                                {
                                    self.wins[i] = "L"
                                }
                                else
                                {
                                    self.wins[i] = "Tie"
                                }
                            }
                            
                        }
                    }
                    i++
                }
                self.tableView.reloadData()
                print(self.locations.count)
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
        singleCell.lType.text = types[indexPath.row]
        singleCell.lMinRating.text = minRatings[indexPath.row].description
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
        self.performSegueWithIdentifier("showView", sender: self)
        
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
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.endRefreshing()
        }
    }
    
    func endRefreshing() {
        refresh.endRefreshing()
    }

}
