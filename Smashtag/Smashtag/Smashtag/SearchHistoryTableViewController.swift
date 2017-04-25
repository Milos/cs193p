//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/21/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
  
  var searchedTerms: [String]?
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    title = "Search History"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // retrieve array from UserDefaults and reverse
    searchedTerms = ((UserDefaults.standard.array(forKey: "searchedTerms") as? [String]))
    tableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // update UserDefaults
    if (searchedTerms != nil) {
      UserDefaults.standard.set(searchedTerms, forKey: "searchedTerms")
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchedTerms?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Searched Term Cell", for: indexPath)
    let latestSearchedTerms:[String]? = searchedTerms?.reversed()
    let searchedTerm = latestSearchedTerms?[indexPath.row]
    cell.textLabel?.text = searchedTerm
    return cell
  }
  
  // MARK: - GESTURES
  
  // swipe to delete
  private var deleteTermIndexPath: IndexPath?
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteTermIndexPath = indexPath
      if let termToDelete = searchedTerms?[indexPath.row] {
        confirmDelete(term: termToDelete)
      }
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
      
      searchedTerms?.remove(at: indexPath.row)
      
      // Note that indexPath is wrapped in an array:  [indexPath]
      tableView.deleteRows(at: [indexPath], with: .automatic)
      
      // remove from UserDefaults
      
      
      deleteTermIndexPath = nil
      
      tableView.endUpdates()
    }
  }
  
  private func cancelDeleteTerm(alertAction: UIAlertAction!) {
    deleteTermIndexPath = nil
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Search Term" {
      if let vc = segue.destination as? HashtagAndUserTableViewController,
        let cell = sender as? TweetTableViewCell {
        vc.searchText = cell.textLabel?.text
      }
    }
  }
  
}
