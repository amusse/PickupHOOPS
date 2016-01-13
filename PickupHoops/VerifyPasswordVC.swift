//
//  VerifyPasswordVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/25/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class VerifyPasswordVC: UIViewController
{
    @IBOutlet weak var tbVerifyPassword: UITextField!   // Verify password text field
    var firstName   = ""
    var lastName    = ""
    var userName    = ""
    var email       = ""
    var password    = ""
    
    // Activity Indiator to perform Parse sign up
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add logo to navigation bar
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        tbVerifyPassword.becomeFirstResponder()
        
        // Center the activity indicator
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Alert that user has signed up
    func displayAlertSuccess()
    {
        let alertController = UIAlertController(
            title: "Registration Complete!",
            message: "We have sent you an email that contains a link - you must click this link before you can log in.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { action in self.performSegueWithIdentifier("toLoginVC", sender: self)}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    // Alert that passwords didn't match
    func displayAlertFailure()
    {
        let alertController = UIAlertController(
            title: "Passwords Do Not Match!",
            message: "Please re-enter your password",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Password")}))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func createUser() -> PFUser
    {
        let newUser = PFUser()
        newUser.username = userName
        newUser.password = password
        newUser.email = email
        newUser["first_name"] = firstName
        newUser["last_name"] = lastName
        newUser["rating"] = 1000
        newUser["gamesPlayed"] = 0
        return newUser
    }
    
    // After pressing "Submit" button, this function signs a user up if possible
    @IBAction func btnSubmit(sender: AnyObject)
    {
        if (passwordsMatch(password, verPass: tbVerifyPassword.text!))
        {
            self.actInd.startAnimating()
            
            let newUser = createUser()
            newUser.signUpInBackgroundWithBlock(
            { (succeed, error) -> Void in
                self.actInd.stopAnimating()
                if ((error) != nil)
                {
                    // Alert that there was an error signing up
                    let alertController = UIAlertController(
                        title: "Error!",
                        message: "\(error)",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: { (alert: UIAlertAction!) in print("Error Signing up")}))
                    
                    self.presentViewController(
                        alertController,
                        animated: true,
                        completion: nil)
                }
                else
                {
                   self.displayAlertSuccess()
                }
            })
        }
        else
        {
            displayAlertFailure()
        }
    }
    
    // After hitting the "Send" key on keyboard, this function signs a user up if possible
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (passwordsMatch(password, verPass: textField.text!))
        {
            self.actInd.startAnimating()
            
            let newUser = createUser()
            newUser.signUpInBackgroundWithBlock(
            { (succeed, error) -> Void in
                self.actInd.stopAnimating()
                if ((error) != nil)
                {
                    let alertController = UIAlertController(
                        title: "Error!",
                        message: "\(error)",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: { (alert: UIAlertAction!) in print("Error Signing up")}))
                    
                    self.presentViewController(
                        alertController,
                        animated: true,
                        completion: nil)
                }
                else
                {
                    self.displayAlertSuccess()
                }
            })
        }
        else
        {
            displayAlertFailure()
        }
        return true
    }
    
    // Determines if passwords match
    func passwordsMatch(pass: NSString, verPass: NSString) -> Bool
    {
        return pass == verPass
    }

    // Displays navigation bar
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}