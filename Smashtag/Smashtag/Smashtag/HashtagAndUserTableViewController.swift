//
//  HashtagAndUserTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/25/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter

class HashtagAndUserTableViewController: UITableViewController {
  
  
  // MARK: - MODEL
  
  private var tweets = [Array<Twitter.Tweet>]()

  
  // MARK: - API
  
  var searchText: String? {
    didSet {
      tweets.removeAll()
      tableView.reloadData()
      searchForTweets()
      title = searchText
    }
  }
  
  // MARK: - Updating the Table
  
  // just creates a Twitter.Request
  // that finds tweets that match our searchText
  private func twitteRequest() -> Twitter.Request? {
    if let query = searchText, !query.isEmpty {
      return Twitter.Request(search: query, count: 100)
    }
    return nil
  }
  
  // we track this so that
  // a) we ignore tweets that come back from other than our last request
  // b) when we want to refresh, we only get tweets newer than our last request
  private var lastTwitterRequest: Twitter.Request?
  
  // takes the searchText part of our Model
  // and fires off a fetch for matching Tweets
  // when they come back (if they're still relevant)
  // we update our tweets array
  // and then let the table view know that we added a section
  // (it will then call our UITableViewDataSource to get what it needs)
  private func searchForTweets() {
    if let request = twitteRequest() {
      lastTwitterRequest = request
      request.fetchTweets {  [weak self] newTweets  in
        DispatchQueue.main.async {
          if request == self?.lastTwitterRequest {
            self?.tweets.insert(newTweets, at: 0) // at the top
            self?.tableView.insertSections([0], with: .fade) // load into table or
          }
        }
      }
    }
  }
  
  // MARK: - View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // we use the row height in the storyboard as an "estimate"
    tableView.estimatedRowHeight = tableView.rowHeight
    // but use whatever autolayout says the height should be as the actual row height
    tableView.rowHeight = UITableViewAutomaticDimension
    // the row height could alternatively be set
    // using the UITableViewDelegate method heightForRowAt
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return tweets.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
      
      // get the tweet that is associated with this row
      // that the table view is asking us to provide a UITableViewCell for
      let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
      
      // Configure the cell...
      // our outlets to our custom UI
      // are connected to this custom UITableViewCell-subclassed cell
      // so we need to tell it which tweet is shown in its row
      // and it can load up its UI through its outlets
      if let tweetCell = cell as? TweetTableViewCell {
        tweetCell.tweet = tweet
      }
      
      return cell
    }

}
