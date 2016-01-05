//
//  GamesVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/27/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class GamesTableVC: UIViewController, UITableViewDelegate
{
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        getGames()
        refresh = CarbonSwipeRefresh(scrollView: self.tableView)
        refresh.setMarginTop(0)
        refresh.colors = [UIColor.blueColor(), UIColor.redColor(), UIColor.orangeColor(), UIColor.greenColor()]
        self.view.addSubview(refresh)
        refresh.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
    }
    
    func getGames()
    {
        let query = PFQuery(className: "Games")
        query.orderByAscending("end")
        query.whereKey("end", greaterThan: NSDate())
        query.findObjectsInBackgroundWithBlock {
            (games:[PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                //found objects
                let i = 0
                for game in games!
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
                        print(game)
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
                    }
                    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let nextVC: GameDetailsVC = self.storyboard!.instantiateViewControllerWithIdentifier("GameDetailsVC") as! GameDetailsVC

        nextVC.location        = locationTitles[indexPath.row]
        nextVC.type            = types[indexPath.row]
        nextVC.minRating       = minRatings[indexPath.row].description
        nextVC.coordinates     = locations[indexPath.row]
        nextVC.start           = startTimes[indexPath.row].description
        nextVC.end             = endTimes[indexPath.row].description
        nextVC.numPlayer       = numPlayers[indexPath.row].description
        nextVC.note            = notes[indexPath.row]
        nextVC.gameID          = gameIDs[indexPath.row]
        
        self.navigationController!.pushViewController(nextVC, animated: true)
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
        return singleCell
    }
    
    func refresh(sender: AnyObject)
    {
        NSLog("REFRESH")
        self.getGames()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.endRefreshing()
        }
    }
    
    func endRefreshing()
    {
        refresh.endRefreshing()
    }
    
}
