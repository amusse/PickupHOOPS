//
//  NewGameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/31/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class NewGameVC: UITableViewController, UITextFieldDelegate
{

    @IBOutlet weak var tvNotes: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tvNotes.text = "Notes"
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
    
}