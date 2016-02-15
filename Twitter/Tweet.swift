//
//  Tweet.swift
//  Twitter
//
//  Created by Dustin Langner on 2/9/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    var id: Int!
    
    var favorited: Bool!
    var retweetCount: Int!
    var retweeted : Bool!
    var favoriteCount: Int!
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as! Int
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = .ShortStyle
        createdAt = formatter.dateFromString(createdAtString!)
        
        
        favorited = (dictionary["favorited"] as? Bool)!
        favoriteCount = dictionary["retweet_count"] as? Int
        retweeted = (dictionary["retweeted"] as? Bool)!
        retweetCount = dictionary["favorite_count"] as? Int
        
    
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
 
    }

}
