//
//  ViewController.swift
//  Twitter
//
//  Created by Dustin Langner on 2/8/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func OnLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil{
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            
            }

        }
    }
}

