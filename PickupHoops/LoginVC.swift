//
//  LoginVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var tbUsername: UITextField!     // Username text field
    @IBOutlet weak var tbPassword: UITextField!     // Password text field
    
    var username = ""
    var password = ""
    
    // Activity Indiator to perform Parse log in
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
    }
    
    // Segue to "Forgot Password" screen after "Forgot password?" 
    // is pressed
    @IBAction func btnForgot(sender: AnyObject)
    {
        self.performSegueWithIdentifier("toForgotVC", sender: self)
    }
    
    // Displays an "Invalid Login" alert
    func displayAlert()
    {
        let alertController = UIAlertController(
            title: "Invalid Login!",
            message: "Username/password is incorrect. Please try again.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in print("Invalid Login")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // Displays an alert saying that the email address of the user that is being
    // logged in has not been verified yet
    func displayNotVerified()
    {
        let alertController = UIAlertController(
            title: "Email address verification",
            message: "We have sent you an email that contains a link - you must click this link before you can log in.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
        style: UIAlertActionStyle.Default,
        handler: { alertController in PFUser.logOut()}))
        
        self.presentViewController(
        alertController,
        animated: true,
        completion: nil)
    }

    // After log in button is pressed, log the user in using the respective Parse log in
    // methods
    @IBAction func btnLogin(sender: AnyObject)
    {
        username = (tbUsername.text?.lowercaseString)!
        password = tbPassword.text!
        username = username.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        password = password.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        
        self.actInd.startAnimating()
        PFUser.logInWithUsernameInBackground(username, password: password, block:
        { (user, error) -> Void in
            self.actInd.stopAnimating()
            if ((user) != nil)
            {
                // Check to see if the email is verified
//                let isEmailVerified = PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue
                let isEmailVerified = true
                if (isEmailVerified == true)
                {
                    self.performSegueWithIdentifier("toHomeVC", sender: self)
                }
                else
                {
//                    self.displayNotVerified()
                }
            }
            else
            {
                self.displayAlert()
            }
        })
    }
    
    // Get rid of the keyboard after pressing the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Go to next textbox after hitting next
        if (textField == tbUsername)
        {
            tbUsername.resignFirstResponder()
            tbPassword.becomeFirstResponder()
        }
            
        // Otherwise try to log in
        else if (textField == tbPassword)
        {
            username = (tbUsername.text?.lowercaseString)!
            password = tbPassword.text!
            username = username.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
            password = password.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
            
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block:
            { (user, error) -> Void in
                self.actInd.stopAnimating()
                if ((user) != nil)
                {
//                    let isEmailVerified = PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue
                    let isEmailVerified = true
                    if (isEmailVerified == true)
                    {
                        self.performSegueWithIdentifier("toHomeVC", sender: self)
                    }
                    else
                    {
//                        self.displayNotVerified()
                    }
                }
                else
                {
                    self.displayAlert()
                }
            })
        }
        return true
    }
}
