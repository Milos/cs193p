//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/4/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController
{
  
  // MARK: - Model
  
  var container: NSPersistentContainer? =
    (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
  
  
  override func insertTweets(_ newTweets: [Twitter.Tweet]) {
    super.insertTweets(newTweets)
    updateDatabase(with: newTweets)
  }
  
  private func updateDatabase(with tweets: [Twitter.Tweet]) {
    container?.performBackgroundTask {  [weak self] context in
      for twitterInfo in tweets {
        // add tweet in data model
        if let searchText = self?.searchText {
            _ = try? Tweet.findOrCreateTweet(query: searchText, matching: twitterInfo, in: context)
        }
      }
      try? context.save()
      print("done laading database")
      self?.printDatabaseStatistics()
    }
    
  }
  private func printDatabaseStatistics() {
    if let context = container?.viewContext {
      context.perform { // do this block of code on the main queue
        if Thread.isMainThread {
          print("on main thread")
        } else {
          print("off main thread")
        }
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        if let tweetCount = (try? context.fetch(request))?.count {
          print("\(tweetCount) tweets")
        }
        if let mentionCount = try? context.count(for: Mention.fetchRequest()) {
          print("\(mentionCount) mentions")
        }
      }

    }
  }
}
