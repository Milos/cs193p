//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/21/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
  
  var searchedTerms: [String]? = nil
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // retrieve array from UserDefaults, ignore empty items and reverse 
    // order so the latest item is at top of the tableview
    searchedTerms = ((UserDefaults.standard.array(forKey: "searchedTerms") as? [String])?.filter {!$0.isEmpty})
    searchedTerms?.reverse()
    tableView.reloadData()
    
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
    
    let searchedTerm = searchedTerms?[indexPath.row]
    cell.textLabel?.text = searchedTerm
    return cell
  }
  
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Search Term" {
      if let vc = segue.destination as? TweetTableViewController,
        let cell = sender as? TweetTableViewCell {
        vc.searchText = cell.textLabel?.text
      }
    }
   }
  
}
