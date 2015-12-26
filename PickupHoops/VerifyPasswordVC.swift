//
//  VerifyPasswordVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/25/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class VerifyPasswordVC: UIViewController {
    
    @IBOutlet weak var tbVerifyPassword: UITextField!
    var firstName   = ""
    var lastName    = ""
    var userName    = ""
    var email       = ""
    var password    = ""
    
    @IBOutlet weak var tPass: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "basketball-nav-bar-2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        tbVerifyPassword.becomeFirstResponder()
    }
    
    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func displayAlertSuccess()
    {
        // Alert that a confirmation email has been sent
        let alertController = UIAlertController(
            title: "Registration Complete!",
            message: "We have sent you an email that contains a link - you must click this link before you can log in.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { action in self.performSegueWithIdentifier("toLoginVC", sender: self)}))
        
        // Display alert
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func displayAlertFailure()
    {
        // Alert that a confirmation email has been sent
        let alertController = UIAlertController(
            title: "Passwords Do Not Match!",
            message: "Please re-enter your password",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (alert: UIAlertAction!) in print("Invalid Password")}))
        
        // Display alert
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    
    @IBAction func btnSubmit(sender: AnyObject)
    {
        // REGISTER USER
        if (passwordsMatch(password, verPass: tbVerifyPassword.text!))
        {
            displayAlertSuccess()
        }
        else
        {
            displayAlertFailure()
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // REGISTER USER
        if (passwordsMatch(password, verPass: textField.text!))
        {
            displayAlertSuccess()
        }
        else
        {
            displayAlertFailure()
        }
        return true
    }
    
    func passwordsMatch(pass: NSString, verPass: NSString) -> Bool
    {
        return true
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