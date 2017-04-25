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
    title = "Search History"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // retrieve array from UserDefaults and reverse
    searchedTerms = ((UserDefaults.standard.array(forKey: "searchedTerms") as? [String]))
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
      if let vc = segue.destination as? HashtagAndUserTableViewController,
        let cell = sender as? TweetTableViewCell {
        vc.searchText = cell.textLabel?.text
      }
    }
   }
  
}
