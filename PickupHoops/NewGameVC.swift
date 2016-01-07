//
//  NewGameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/31/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class NewGameVC: UITableViewController, UITextViewDelegate
{

    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var lEndTime: UILabel!
    @IBOutlet weak var lStartTime: UILabel!
    @IBOutlet weak var pckrDate: UIDatePicker!
    @IBOutlet weak var btnPickerDone: UIButton!
    @IBOutlet weak var lLocation: UILabel!
    @IBOutlet weak var nbDate: UINavigationBar!
    
    var row: Int = 0
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationTitle = ""
    var currentUser: PFUser!
    var latitude = ""
    var longitude = ""
    var startTime: NSDate!
    var endTime: NSDate!
    var rating = 0
    var notes = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        
        tvNotes.delegate = self
        tvNotes.text = "Notes"
        tvNotes.textColor = UIColor.lightGrayColor()
        
        tvNotes.layer.borderWidth = 0.1
        tvNotes.layer.cornerRadius = 10
        pckrDate.hidden = true
        btnPickerDone.hidden = true
        nbDate.hidden = true
        lLocation.text = "Location"
    }
    
    func textViewDidChange(textView: UITextView)
    { //Handle the text changes here
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor()
        {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty
        {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGrayColor()
        }
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
        
        // Assign leader to team A
        let teamA = NSMutableArray()
        teamA.addObject(username!)
        
        notes = tvNotes.text!
        
        let game = PFObject(className: "Games")
        game["type"]        = "Public"
        game["location"]    = PFGeoPoint(latitude: Double(latitude)!, longitude: Double(longitude)!)
        game["locationTitle"] = locationTitle
        game["start"]       = startTime
        game["end"]         = endTime
        game["min_rating"]  = 0
        game["notes"]       = notes
        game["num_players"] = 1
        game["players"]     = players
        game["host"]        = username
        game["full"]        = false
        game["teamA"]       = teamA
        game["teamB"]       = NSMutableArray()
        game["winsA"]       = 0
        game["winsB"]       = 0
        game["winner"]      = "A"
        game["avg_rating"]  = currentUser!.objectForKey("rating") as! Int
        
        
        game.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        row = indexPath.row
        if (indexPath.row == 2 || indexPath.row == 3)
        {
            pckrDate.hidden = false
            btnPickerDone.hidden = false
            nbDate.hidden = false
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
            startTime = pckrDate.date
        }
        else if(row == 3)
        {
            lEndTime.text = strDate
            endTime = pckrDate.date
        }
    }

    @IBAction func btnPickerDone(sender: AnyObject)
    {
        pckrDate.hidden = true
        btnPickerDone.hidden = true
        nbDate.hidden = true
    }
   
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
    {
        let mapVC: MapVC = unwindSegue.sourceViewController as! MapVC
        selectedLocation = mapVC.selectedLocation
        locationTitle = mapVC.locationTitle
        latitude = selectedLocation.latitude.description
        longitude = selectedLocation.longitude.description
        
        lLocation.text = locationTitle
        
    }
    
    
}