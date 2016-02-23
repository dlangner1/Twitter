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
    var username: String?
    var name: String?
    var profileImageURL: String?
    var tweetId: String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var replyToScreename: String?
    
    var dictionary: NSDictionary
    var retweeted_status: NSDictionary?

    
    var timePassed: Int?
    var timeSince: String!
    
    var favorited: Bool!
    var retweetCount: Int!
    var retweeted : Bool!
    var favoriteCount: Int!
    var replied: Bool!
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        username = user!.screenName
        name = user!.name
        profileImageURL = user!.profileImageURL
        text = dictionary["text"] as? String
        favorited = (dictionary["favorited"] as? Bool)!
        favoriteCount = dictionary["retweet_count"] as? Int
        retweeted = (dictionary["retweeted"] as? Bool)!
        retweetCount = dictionary["favorite_count"] as? Int
        replyToScreename = dictionary["in_reply_to_status_id_str"] as? String
        retweeted_status = dictionary["retweeted_status"] as? NSDictionary
        tweetId = dictionary["id_str"] as? String
        
        // modifies the timestamp
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let now = NSDate()
        let then = createdAt
        timePassed = Int(now.timeIntervalSinceDate(then!))

        if timePassed >= 86400 {
            timeSince = String(timePassed! / 86400)+"d"
        }
        if (3600..<86400).contains(timePassed!){
            timeSince = String(timePassed!/3600)+"h"
        }
        if (60..<3600).contains(timePassed!){
            timeSince = String(timePassed!/60)+"m"
        }
        if timePassed < 60 {
            timeSince = String(timePassed!)+"s"
        }

    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
