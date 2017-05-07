//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/21/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
  
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    title = "Search History"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RecentSearches.searches.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Searched Term Cell", for: indexPath)
    cell.textLabel?.text = RecentSearches.searches[indexPath.row]
    return cell
  }
  
  // MARK: - GESTURES
  
  // swipe to delete
  private var deleteTermIndexPath: IndexPath?
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteTermIndexPath = indexPath
      confirmDelete(term: RecentSearches.searches[indexPath.row])
    }
  }
  
  private func confirmDelete(term: String) {
    let alert = UIAlertController(title: "Delete searched term", message: "Are you sure you want to permanently delete \(term)?", preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteTerm)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteTerm)
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  // handlers
  private func handleDeleteTerm(alertAction: UIAlertAction!) -> Void {
    if let indexPath = deleteTermIndexPath {
      tableView.beginUpdates()
      
       RecentSearches.remove(at: indexPath.row)
      
      // Note that indexPath is wrapped in an array:  [indexPath]
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      deleteTermIndexPath = nil
      
      tableView.endUpdates()
    }
  }
  
  private func cancelDeleteTerm(alertAction: UIAlertAction!) {
    deleteTermIndexPath = nil
  }
  
  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Popular Mentions" {
      if let vc = segue.destination as? PopularMentionsTableViewController,
        let cell = sender as? TweetTableViewCell {
        vc.mention = cell.textLabel?.text?.lowercased()
      }
    }
  }
  
}
