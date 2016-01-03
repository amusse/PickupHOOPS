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
    
    var row: Int = 0
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        }
        else if(row == 3)
        {
            lEndTime.text = strDate
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
        lLocation.text = "coordinate: \(selectedLocation.latitude), \(selectedLocation.longitude)"
    }
    
    
}