//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Dustin Langner on 2/14/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        //tableView.rowHeight = UITableViewAutomaticDimension

        // create navigation bar and set color
        if let navBar = self.navigationController?.navigationBar {
            
            navBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        User.currentUser?.logout()
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    var selectedTweet: Tweet!
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedTweet = tweets![indexPath.row]
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func onReply(notification: NSNotification) {
        performSegueWithIdentifier("composeSegue", sender: notification.userInfo!["repliedToTweet"])
    }
    
    @IBAction func cancelToTweetsViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func tweetToTweetsViewController(segue:UIStoryboardSegue) {
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileSegue" {
            
            let button = sender as! UIButton
            
            var superView = button.superview
            while superView != nil {
                if let tweetCell = superView as? TweetCell {
                    if let selectedUser = tweetCell.tweet.user {
                        let profileViewController = segue.destinationViewController as! ProfileViewController
                        profileViewController.user = selectedUser
                        
                        superView = nil
                    }
                } else {
                    superView = superView?.superview
                }
            }
            
        } else if segue.identifier == "tweetDetailsSegue" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetViewController = segue.destinationViewController as! TweetViewController
            tweetViewController.tweet = tweet
            
        } else if segue.identifier == "composeSegue" {
            if let tweet = sender as? Tweet {
                let composeViewController = segue.destinationViewController as! ComposeViewController
                    composeViewController.replyTweet = tweet
  
            }
        } else if segue.identifier == "replySegue" {
            print("started replying")
            if let tweet = sender as? Tweet {
                let composeViewController = segue.destinationViewController as! ComposeViewController
                composeViewController.replyTweet = tweet
                let replyHandle  = "@\((tweet.user?.screenName!)!) " as String
            
                composeViewController.tweetId = (tweet.tweetId!)
                composeViewController.replyTo = replyHandle
                composeViewController.isReply = true
            }
        }
    }
}