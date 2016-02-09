//
//  TwitterClient.swift
//  Twitter
//
//  Created by Dustin Langner on 2/8/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "ACX3k1YO9HpVUrs58PO7b5w1A"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerSecret = "fPO3zyIIGalbFLADSZnaxUque4cKn3UKklr1lckbobncNyI6Uu"

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        
        }
        return Static.instance
    }

}
