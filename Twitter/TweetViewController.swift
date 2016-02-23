//
//  TweetViewController.swift
//  Twitter
//
//  Created by Dustin Langner on 2/21/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweets: [Tweet]?
    var tweet: Tweet!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL = NSURL(string: tweet.profileImageURL!)
        avatarView.setImageWithURL(imageURL!)
        usernameLabel.text = tweet.name
        handleLabel.text = "@\(tweet.username!)"
        tweetLabel.text = tweet.text
        favoriteLabel.text = "\(tweet.favoriteCount!)"
        retweetLabel.text = "\(tweet.retweetCount!)"
        if tweet.favorited == true {
            favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: UIControlState.Normal)
            favoriteLabel.text = String(tweet!.favoriteCount! + 1)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action-off"), forState: UIControlState.Normal)
        }
        if tweet.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: UIControlState.Normal)
            retweetLabel.text = String(tweet!.retweetCount! + 1)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: UIControlState.Normal)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if (tweet.retweeted == false) {
            
            TwitterClient.sharedInstance.retweetWithParams(tweet.tweetId!, params: nil, completion: { (error) -> ()in

                self.retweetLabel.text = "\(self.tweet.retweetCount! + 1)"
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
            })
        } else {
            TwitterClient.sharedInstance.unretweetWithParams(tweet.tweetId!, tweet: tweet, params: nil, completion: { (error) -> () in
                self.retweetLabel.text = "\(self.tweet.retweetCount!)"
                self.retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
            })
        }
        tweet.retweeted = !tweet.retweeted
    }
    
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if tweet.favorited == false {
            TwitterClient.sharedInstance.favoriteWithParams(tweet.tweetId!, params: nil, completion: { (error) -> ()in
                self.favoriteLabel.text = "\(self.tweet.retweetCount! + 1)"
                self.favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
            })
        } else {
            TwitterClient.sharedInstance.unfavoriteWithParams(tweet.tweetId!, params: nil, completion: { (error) -> () in
                self.favoriteLabel.text = "\(self.tweet.retweetCount!)"
                self.favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
            })
        }
        tweet.favorited = !tweet.favorited
    }
    
    @IBAction func onReplyPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("replied", object: nil, userInfo: ["repliedToTweet": tweet])

    }
}