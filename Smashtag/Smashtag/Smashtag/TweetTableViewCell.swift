//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Milos Menicanin on 3/21/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
  
  // outlets to the UI components in our Custom UITableViewCell
  @IBOutlet weak var tweetProfileImageView: UIImageView!
  @IBOutlet weak var tweetCreatedLabel: UILabel!
  @IBOutlet weak var tweetUserLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  // public API of this UITableViewCell subclass
  // each row in the table has its own instance of this class
  // and each instance will have its own tweet to show
  // as set by this var
  var tweet: Twitter.Tweet? { didSet { updateUI() } }
  
  
  private func updateUI() {
    if let tweet = tweet {
      
      // Highlight url, hastags and screen names mentioned in the tweet
      let atributedText = NSMutableAttributedString(string: tweet.text)
      
      for url in tweet.urls {
        atributedText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: url.nsrange)
      }
      for hashtags in tweet.hashtags {
        atributedText.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: hashtags.nsrange)
      }
      for userMentions in tweet.userMentions {
        atributedText.addAttributes([NSForegroundColorAttributeName: UIColor.purple], range: userMentions.nsrange)
      }
      
      tweetTextLabel.attributedText = atributedText
    }
    
    
    tweetUserLabel?.text = tweet?.user.description
    
    tweetProfileImageView.image = nil
    if let profileImageURL = tweet?.user.profileImageURL {
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        if let imageData = try? Data(contentsOf: profileImageURL) {
          DispatchQueue.main.async {
            if profileImageURL == self?.tweet?.user.profileImageURL {
              self?.tweetProfileImageView.image = UIImage(data: imageData)
            }
          }
        }
      }
    } else {
      tweetProfileImageView.image = nil
    }
    
    if let created = tweet?.created {
      let formatter = DateFormatter()
      if Date().timeIntervalSince(created) > 24*60*60 {
        formatter.dateStyle = .short
      } else {
        formatter.timeStyle = .short
      }
      tweetCreatedLabel?.text = formatter.string(from: created)
    } else {
      tweetCreatedLabel?.text = nil
    }
  }
  
}
