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
let twitterConsumerSecret = "fPO3zyIIGalbFLADSZnaxUque4cKn3UKklr1lckbobncNyI6Uu"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation:NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query)!, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation:NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func retweet(id: Int) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation, response) -> Void in
            print("succesfully retweeted")
            
            }, failure: { (operation, error) -> Void in
                print("error retweeting")
        })
    }
    
    func favoriteTweet(id: Int) {
        POST("1.1/favorites/create.json", parameters: ["id": id], success: { (operation, response) -> Void in
            print("succesfully favorited")
            
            }, failure: { (operation, error) -> Void in
                print("error favoriting")
        })
    }
    
    func unFavoriteTweet(id: Int) {
        POST("1.1/favorites/destroy.json", parameters: ["id": id], success: { (operation, response) -> Void in
            print("succesfully unfavorited")
            
            }, failure: { (operation, error) -> Void in
                print("error unfavoriting")
        })
    }
    
    
    func tweet(status: String) {
        POST("1.1/statuses/update.json", parameters: ["status": status], success: { (operation, response) -> Void in
            print("succesfully tweeted")
            
            }, failure: { (operation, error) -> Void in
                print("error tweeting")
        })
    }
    
    
    func untweet(id: Int) {
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil,  success: { (operation, response) -> Void in
            print("succesfully untweeted")
            
            }, failure: { (operation, error) -> Void in
                print("error untweeting")
        })
    }
    
    func getTweet(id: Int) -> Tweet {
        
        var tweet: Tweet!
        
        GET("1.1/statuses/show.json", parameters: ["id", id], progress: { (progress) -> Void in
            print("getting tweet")
            }, success: { (session, object) -> Void in
                tweet = object as! Tweet
            }) { (dataTask, error) -> Void in
                
        }
        return tweet
    }
    
    func getUser(id: Int) -> Tweet {
        
        var tweet: Tweet!
        
        GET("1.1/statuses/show.json", parameters: ["id", id], progress: { (progress) -> Void in
            print("getting tweet")
            }, success: { (session, object) -> Void in
                tweet = object as! Tweet
            }) { (dataTask, error) -> Void in
                
        }
        return tweet
    }

}
