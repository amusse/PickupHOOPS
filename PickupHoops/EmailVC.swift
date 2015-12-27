//
//  EmailVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/25/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class EmailVC: UIViewController
{
    @IBOutlet weak var tbEmail: UITextField!    // Email text field
    var firstName   = ""
    var lastName    = ""
    var userName    = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add logo to navigation bar
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        tbEmail.becomeFirstResponder()
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Displays alert that email is invalid
    func displayAlert()
    {
        let alertController = UIAlertController(
            title: "Invalid Email!",
            message: "Sorry, please enter a valid email address.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Email")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // After "Next" button is pressed, perform a segue to next screen
    @IBAction func btnNext(sender: AnyObject)
    {
        if (emailIsValid(tbEmail.text!))
        {
            self.performSegueWithIdentifier("toPasswordVC", sender: self)
        }
        else
        {
            displayAlert()
        }
    }
    
    // Perform a segue after hitting "Next" on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (emailIsValid(textField.text!))
        {
            self.performSegueWithIdentifier("toPasswordVC", sender: self)
        }
        else
        {
            displayAlert()
        }
        return true
    }
    
    // Checks if email is valid
    func emailIsValid(username: NSString) -> Bool
    {
        var notExist: Bool = true
        var isEmail: Bool
        {
            do
            {
                let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
                return regex.firstMatchInString(tbEmail.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, tbEmail.text!.characters.count)) != nil
            }
            catch
            {
                return false
            }
        }
        if (isEmail)
        {
            let emailQuery = PFUser.query()
            emailQuery!.whereKey("email", equalTo: tbEmail.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet()))
            emailQuery!.findObjectsInBackgroundWithBlock
            {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil
                    {
                        // The find succeeded.
                        notExist = false
                    }
                    else
                    {
                        notExist = true
                    }
            }
            return notExist
        }
        else
        {
            return false
        }
    }
    
    // Send previous data to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! PasswordVC
        nextVC.firstName    = firstName
        nextVC.lastName     = lastName
        nextVC.userName     = userName
        nextVC.email        = tbEmail.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        
    }
    
    // Displays navigation bar
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}