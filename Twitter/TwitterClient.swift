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
    
    func userTimeline(screenname: String, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error retrieving info: \(error)")
                
                completion(tweet: nil, error: error)
                self.loginCompletion!(user: nil, error: error)
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
    
    func newTweetWithParams(params: NSDictionary!, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted successfully")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("did not tweet")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweetWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        print(id)
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully retweeted")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                completion(error: error)
        })
    }
    
    func unretweetWithParams(id: String, tweet: Tweet?, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        var originalTweetId = ""
        var retweetId = ""
        if tweet!.retweeted == false {
            print("cannot untweet if have not retweeted")
        } else if tweet!.retweeted_status == nil{
            originalTweetId = tweet!.tweetId!
        } else {
            originalTweetId = tweet!.retweeted_status!["id_str"] as! String
        }
        
        GET("1.1/statuses/show/\(originalTweetId).json?include_my_retweet=1", parameters: params, success: { (operation: NSURLSessionDataTask!,response: AnyObject?) -> Void in
            let fullTweet = response as! NSDictionary
            let retweet = fullTweet["current_user_retweet"]!
            retweetId = retweet["id_str"] as! String
            print("got full tweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting full tweet")
        })
        
        
        POST("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully unretweeted")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unretweeting")
                completion(error: error)
        })
    }
    
    
    func favoriteWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully favorited")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error favoriting")
                completion(error: error)
        })
    }
    
    func unfavoriteWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully unfavorited")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unfavoriting")
                completion(error: error)
        })
    }
    
    func tweet(tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        POST("1.1/statuses/update.json?status=\(escapedText)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("You tweeted!!")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    
    func reply(tweetId: String, tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        print("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)")
        POST("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("replied")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
}