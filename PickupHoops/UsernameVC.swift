//
//  UsernameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/25/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class UsernameVC: UIViewController {
    
    @IBOutlet weak var tbUsername: UITextField!
    var firstName   = ""
    var lastName    = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        tbUsername.becomeFirstResponder()
    }
    
    func displayAlert()
    {
        // Alert that a confirmation email has been sent
        let alertController = UIAlertController(
            title: "Username already taken!",
            message: "Sorry, this username is already taken. Please choose another one.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Username")}))
        
        // Display alert
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
    
    @IBAction func btnNext(sender: AnyObject)
    {
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
        return true
    }
    
    // Send previous data to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! EmailVC
        nextVC.firstName    = firstName
        nextVC.lastName     = lastName
        nextVC.userName     = tbUsername.text!
    }

    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}