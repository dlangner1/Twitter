//
//  TweetCell.swift
//  Twitter
//
//  Created by Dustin Langner on 2/14/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var tweetID: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 6
        profileImageView.clipsToBounds = true
    }
    
    var tweet: Tweet! {
        didSet {
            userName.text = tweet.user?.name
            userHandle.text = "@\((tweet.user?.screenName)!)"
            tweetDescriptionLabel.text = tweet.text
            timestampLabel.text = tweet.createdAtString
            retweetCount.text = "\(tweet.retweetCount)"
            favoriteCount.text = "\(tweet.favoriteCount)"
            self.profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL!)!)!)
            
            retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
            favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)


        }
    }
        
    @IBAction func onRetweetPressed(sender: AnyObject) {
        if tweet.retweeted == false {
            retweetCount.text = "\(tweet.retweetCount! + 1)"
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
        } else {
            retweetCount.text = "\(tweet.retweetCount!)"
            retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
        }
            
        tweet.retweeted = !tweet.retweeted
        
    }
        
    @IBAction func onFavoritePressed(sender: AnyObject) {
        if tweet.favorited == false {
            favoriteCount.text = "\(tweet.retweetCount! + 1)"
            favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
        } else {
            favoriteCount.text = "\(tweet.retweetCount!)"
            favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
        }
        
        tweet.favorited = !tweet.favorited

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
