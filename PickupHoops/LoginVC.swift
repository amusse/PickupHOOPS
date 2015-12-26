//
//  LoginVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UITableViewController {
    
    @IBOutlet weak var tbUsername: UITextField!
    @IBOutlet weak var tbPassword: UITextField!
    
    var username = ""
    var password = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func displayAlert()
    {
        // Alert that login is invalid
        let alertController = UIAlertController(
            title: "Invalid Login!",
            message: "Username/password is incorrect. Please try again.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in print("Invalid Login")}))
        
        // Display alert
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    @IBAction func btnLogin(sender: AnyObject)
    {
        username = tbUsername.text!
        password = tbPassword.text!
        if (isAuthenticated(username, password: password))
        {
            self.performSegueWithIdentifier("toHomeVC", sender: self)
        }
        else
        {
            displayAlert()
        }

    }
    
    
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
            username = tbUsername.text!
            password = tbPassword.text!
            if (isAuthenticated(username, password: password))
            {
                self.performSegueWithIdentifier("toHomeVC", sender: self)
            }
            else
            {
                displayAlert()
            }
        }
        return true
    }
    
    // Determine if user logged in properly
    func isAuthenticated(username: NSString, password: NSString) -> Bool
    {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
