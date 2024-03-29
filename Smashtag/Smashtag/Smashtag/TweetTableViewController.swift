//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 3/20/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
  
  
  // MARK: Model

  private var tweets = [Array<Twitter.Tweet>]()
  
  var searchText: String? {
    didSet {
      guard let text = searchText, !text.isEmpty else {
        return
      }
      searchTextField?.text = searchText
      searchTextField?.resignFirstResponder() // keyboard
      lastTwitterRequest = nil
      tweets.removeAll()
      tableView.reloadData()
      searchForTweets()
      RecentSearches.add(text)
      title = searchText
    }
  }
  
  func insertTweets(_ newTweets: [Twitter.Tweet]) {
    self.tweets.insert(newTweets, at: 0) // at the top
    self.tableView.insertSections([0], with: .fade) // load into table or
  }
  
  // MARK: Updating the Table
  
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
    if let request = lastTwitterRequest?.newer ?? twitteRequest() {
      print("searchForTweeets")
      lastTwitterRequest = request
      request.fetchTweets {  [weak self] newTweets  in // this is off the main queue
        DispatchQueue.main.async { // so we must dispatch back to main queue
          if request == self?.lastTwitterRequest {
            self?.insertTweets(newTweets)
          }
          self?.refreshControl?.endRefreshing() // REFRESHING
        }
      }
    } else {
      self.refreshControl?.endRefreshing() // REFRESHING
    }
  }
  
  @IBAction func refresh(_ sender: UIRefreshControl) {
    print("searchForTweets()")
    searchForTweets()
  }
  
  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // we use the row height in the storyboard as an "estimate"
    tableView.estimatedRowHeight = tableView.rowHeight
    // but use whatever autolayout says the height should be as the actual row height
    tableView.rowHeight = UITableViewAutomaticDimension
    // the row height could alternatively be set
    // using the UITableViewDelegate method heightForRowAt
  }
  
  // MARK: Search Text Field
  
  // set ourself to be the UITextFieldDelegate
  // so that we can get textFieldShouldReturn sent to us
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField?.delegate = self
    }
  }
  
  // when the return (i.e. Search) button is pressed in the keyboard
  // we go off to search for the text in the searchTextField
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == searchTextField {
      searchText = searchTextField.text
    }
    return true
  }
  
  // MARK: - UITableViewDataSource
  
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
    // the textLabel and detailTextLabel are for non-Custom cells
    //    cell.textLabel?.text = tweet.text
    //    cell.detailTextLabel?.text = tweet.user.name
    // our outlets to our custom UI
    // are connected to this custom UITableViewCell-subclassed cell
    // so we need to tell it which tweet is shown in its row
    // and it can load up its UI through its outlets
    if let tweetCell = cell as? TweetTableViewCell {
      tweetCell.tweet = tweet
    }
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Tweet Detail" {
      if let vc = segue.destination as? MentionsTableViewController,
        let cell = sender as? TweetTableViewCell {
        vc.tweet = cell.tweet
      }
    }
  }
  
}

