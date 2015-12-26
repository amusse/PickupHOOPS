//
//  FirstNameVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 12/23/15.
//  Copyright © 2015 Pickup Sports. All rights reserved.
//

import UIKit
import Parse

class FirstNameVC: UIViewController {
    
    @IBOutlet weak var tbFirstName: UITextField!
    
    // Put the logo on the navigation bar and make the keyboard appear
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
    // Perform a segue after hitting "Next" on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        self.performSegueWithIdentifier("toLastNameVC", sender: self)
        return true
    }
    
    // Return to previous view after hitting the button "Cancel"
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Send First Name data to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let nextVC = segue.destinationViewController as! LastNameVC
        nextVC.firstName = tbFirstName.text!
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}