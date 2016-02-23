//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Dustin Langner on 2/21/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit


class ComposeViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    var replyTweet: Tweet?
    let maxChars = 140
    var user: User!
    var tweet: Tweet!
    var replyTo: String = ""
    var tweetId: String = ""
    var isReply: Bool?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.becomeFirstResponder()
        
        textView.text = replyTo
        charCount.text = "\(maxChars - textView.text.characters.count)"

        

        if replyTweet != nil {
            textView.text = "@\(replyTweet!.user!.screenName!): "
            charCount.text = "\(maxChars - textView.text.characters.count)"
        }
        
        let currentUser = User.currentUser!
        let imageUrl = NSURL(string: currentUser.profileImageURL!)
        profileImageView.setImageWithURL(imageUrl!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        let count = textView.text.characters.count
        charCount.text = "\(140-count)"
        if (140-count) < 0 {
            charCount.textColor = UIColor.redColor()
        } else {
            charCount.textColor = UIColor.grayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= maxChars
    }
    
    @IBAction func onTweet(sender: UIBarButtonItem) {
        if isReply == true {
            TwitterClient.sharedInstance.reply(tweetId, tweetText: "\(textView.text)")
        } else {
            TwitterClient.sharedInstance.tweet(textView.text)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

}
