//
//  UsernameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/25/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class UsernameVC: UIViewController
{
    @IBOutlet weak var tbUsername: UITextField!     // Username text field
    var firstName   = ""
    var lastName    = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add logo to navigation bar
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        tbUsername.becomeFirstResponder()
    }
    
    // Displays alert that username is already taken
    func displayAlert()
    {
        
        let alertController = UIAlertController(
            title: "Username already taken!",
            message: "Sorry, this username is already taken. Please choose another one.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Username")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // After "Next" button is pressed, perform a segue to next screen
    @IBAction func btnNext(sender: AnyObject)
    {
        var username = tbUsername.text!.lowercaseString
        username = username.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        if (usernameIsValid(tbUsername.text!))
        {
            self.performSegueWithIdentifier("toEmailVC", sender: self)
        }
        else
        {
            displayAlert()
        }
    }
    
    // Perform a segue after hitting "Next" on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        var username = tbUsername.text!.lowercaseString
        username = username.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        if (usernameIsValid(textField.text!))
        {
            self.performSegueWithIdentifier("toEmailVC", sender: self)
        }
        else
        {
            displayAlert()
        }
        return true
    }
    
    // Checks if username is valid
    func usernameIsValid(username: NSString) -> Bool
    {
        var isValid = true
        let usernameQuery = PFUser.query()
        usernameQuery!.whereKey("username", equalTo: tbUsername.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet()))
        usernameQuery!.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                // The find succeeded.
                isValid = false
            }
            else
            {
                isValid = true
            }
        }
        return isValid
    }
    
    // Send previous data to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! EmailVC
        nextVC.firstName    = firstName
        nextVC.lastName     = lastName
        nextVC.userName     = tbUsername.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
    }

    // Displays navigation bar
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}