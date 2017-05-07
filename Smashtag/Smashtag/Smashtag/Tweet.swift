//
//  Tweet.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/4/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject
{
  class func findOrCreateTweet(query: String, matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet
  {
    // find tweet
    let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
    // which tweet in database
    request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 { // tweet has been found
        assert(matches.count == 1, "Tweet.findOrCreateTweet - database inconcistency")
        return matches[0]
      }
    } catch {
      throw error
    }
    
    // create tweet
    let tweet = Tweet(context: context)
    tweet.unique = twitterInfo.identifier
    
    // return tweet
    return addMention(query: query, tweet: tweet, twitterInfo: twitterInfo, in: context)
  }
  
  class func addMention(query: String, tweet: Tweet, twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) -> Tweet
  {
    let tweetMentions = twitterInfo.hashtags + twitterInfo.userMentions
    
    for mentionInfo in tweetMentions {
      if let mention = try? Mention.findOrCreateMention(query: query, matching: mentionInfo, in: context) {
        tweet.addToMentions(mention)

      }
    }
    
    return tweet
  }
}
