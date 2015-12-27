//
//  ForgotPasswordVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/27/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordVC: UIViewController
{
    @IBOutlet weak var tbEmail: UITextField!     // Email text field
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tbEmail.becomeFirstResponder()
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Displays alert that password was reset
    func displayAlertSuccess()
    {
        let alertController = UIAlertController(
            title: "Password Reset!",
            message: "An email has been sent to your email address." +
            " Please follow the instructions included in the email to reset your password.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { action in self.dismissViewControllerAnimated(true, completion: nil)}))
    
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // Displays alert that there was an error resetting password
    func displayAlertFailure(failMessage: String)
    {
        let alertController = UIAlertController(
            title: "Failure!",
            message: failMessage,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Request")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // After pressing the "Reset Password" button, we use the respective Parse method to 
    // reset the user password
    @IBAction func btnReset(sender: AnyObject)
    {
        let userEmail = tbEmail.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(userEmail)
        {
            (success:Bool, error:NSError?) -> Void in
            if (success)
            {
                self.displayAlertSuccess()
            }
            if (error != nil)
            {
                self.displayAlertFailure(error!.userInfo["error"] as! String)
            }
        }
    }
    
    // After pressing the "Go" key on the keyboard, we use the respective Parse method to
    // reset the user password
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let userEmail = tbEmail.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(userEmail)
        {
                (success:Bool, error:NSError?) -> Void in
                if (success)
                {
                    self.displayAlertSuccess()
                }
                if (error != nil)
                {
                    self.displayAlertFailure(error!.userInfo["error"] as! String)
                }
        }
        return true
    }
    
    // Return to previous view after hitting the button "X"
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}