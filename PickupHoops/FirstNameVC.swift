//
//  FirstNameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class FirstNameVC: UIViewController
{
    @IBOutlet weak var tbFirstName: UITextField!    // First name text field
    
    // Put the logo on the navigation bar and make the keyboard appear
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add logo to navigation bar
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        tbFirstName.becomeFirstResponder()
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Displays alert that first name is invalid
    func displayAlert()
    {
        let alertController = UIAlertController(
            title: "Invalid Entry!",
            message: "Please re-enter your first name.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid First Name")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }

    
    // Perform a segue after hitting "Next" on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (tbFirstName.text!.isEmpty)
        {
            displayAlert()
        }
        else
        {
            self.performSegueWithIdentifier("toLastNameVC", sender: self)
        }
        return true
    }
    
    // After "Next" button is pressed, perform a segue to next screen
    @IBAction func btnNext(sender: AnyObject)
    {
        if (tbFirstName.text!.isEmpty)
        {
            displayAlert()
        }
        else
        {
            self.performSegueWithIdentifier("toLastNameVC", sender: self)
        }
    }
    
    // Return to previous view after hitting the button "X"
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Send first name string to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! LastNameVC
        nextVC.firstName = tbFirstName.text!.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
    }
}