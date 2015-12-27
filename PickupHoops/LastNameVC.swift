//
//  LastNameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class LastNameVC: UIViewController
{
    @IBOutlet weak var tbLastName: UITextField!     // Last name text field
    var firstName = ""                              // First name from previous view
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add logo to navigation bar
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        tbLastName.becomeFirstResponder()
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Displays alert that last name is invalid
    func displayAlert()
    {
        let alertController = UIAlertController(
            title: "Invalid Entry!",
            message: "Please re-enter your last name.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Last Name")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // After "Next" button is pressed, perform a segue to next screen
    @IBAction func btnNext(sender: AnyObject)
    {
        if (tbLastName.text!.isEmpty)
        {
            displayAlert()
        }
        else
        {
            self.performSegueWithIdentifier("toUsernameVC", sender: self)
        }

    }
    // Perform a segue after hitting "Next" on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (tbLastName.text!.isEmpty)
        {
            displayAlert()
        }
        else
        {
            self.performSegueWithIdentifier("toUsernameVC", sender: self)
        }
        return true
    }
    
    // Send last name and first name strings to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! UsernameVC
        nextVC.firstName    = firstName
        nextVC.lastName     = tbLastName.text!.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
    }
    
    // Displays the navigation bar
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}