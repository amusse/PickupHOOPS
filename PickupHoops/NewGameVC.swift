//
//  NewGameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/31/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class NewGameVC: UITableViewController
{

    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var lEndTime: UILabel!
    @IBOutlet weak var lStartTime: UILabel!
    @IBOutlet weak var pckrDate: UIDatePicker!
    @IBOutlet weak var btnPickerDone: UIButton!
    @IBOutlet weak var lLocation: UILabel!
    @IBOutlet weak var scType: UISegmentedControl!
    @IBOutlet weak var txtRating: UITextField!
    
    var row: Int = 0
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var currentUser: PFUser!
    var latitude = ""
    var longitude = ""
    var startTime = ""
    var endTime = ""
    var rating = 0
    var notes = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        
        tvNotes.text = "Notes"
        pckrDate.hidden = true
        btnPickerDone.hidden = true
        lLocation.text = "coordinate: \(selectedLocation.latitude), \(selectedLocation.longitude)"
    }
    
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnDone(sender: AnyObject)
    {
        // Create new game object
        let username = currentUser.username
        let players = NSMutableArray()
        players.addObject(username!)
        
        notes = tvNotes.text!
        rating = Int(txtRating.text!)!
        
        
        let game = PFObject(className: "Game")
        game["type"]        = scType.titleForSegmentAtIndex(scType.selectedSegmentIndex)
        game["location"]    = PFGeoPoint(latitude: Double(latitude)!, longitude: Double(longitude)!)
        game["start"]       = startTime
        game["end"]         = endTime
        game["min_rating"]  = rating
        game["notes"]       = notes
        game["num_players"] = 1
        game["players"]     = players
        game["host"]        = username
        
        game.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        row = indexPath.row
        if (indexPath.row == 2 || indexPath.row == 3)
        {
            pckrDate.hidden = false
            btnPickerDone.hidden = false
        }
        else if (indexPath.row == 1)
        {
            self.performSegueWithIdentifier("MapVC", sender: self)
        }
    }
    
    @IBAction func pckDate(sender: AnyObject)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let strDate = dateFormatter.stringFromDate(pckrDate.date)
        if (row == 2)
        {
           lStartTime.text = strDate
            startTime = strDate
        }
        else if(row == 3)
        {
            lEndTime.text = strDate
            endTime = strDate
        }
    }

    @IBAction func btnPickerDone(sender: AnyObject)
    {
        pckrDate.hidden = true
        btnPickerDone.hidden = true
    }
   
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
    {
        let mapVC: MapVC = unwindSegue.sourceViewController as! MapVC
        selectedLocation = mapVC.selectedLocation
        latitude = selectedLocation.latitude.description
        longitude = selectedLocation.longitude.description
        
        lLocation.text = "coordinate: " + latitude + ", " + longitude
        
    }
    
    
}