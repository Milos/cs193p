//
//  PopularMentionsTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/7/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionsTableViewController: FetchedResultsTableViewController
{
  var mention: String? { didSet { updateUI() } }
  
  var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
  { didSet { updateUI() } }
  
  var fetchedResultsController: NSFetchedResultsController<Mention>?
  
  private func updateUI() {
    title = mention
    if let context = container?.viewContext, mention != nil {
      let request: NSFetchRequest<Mention> = Mention.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false),
                                 NSSortDescriptor(key: "text", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
      request.predicate = NSPredicate(format: "any searchedTerm.text contains[c] %@ AND popularity > 1", mention!)
      fetchedResultsController = NSFetchedResultsController<Mention>(
        fetchRequest: request,
        managedObjectContext: context,
        sectionNameKeyPath: nil,
        cacheName: nil
      )
      try? fetchedResultsController?.performFetch()
      fetchedResultsController?.delegate = self
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Mention Cell", for: indexPath)
    
    // load with info
    if let mention = fetchedResultsController?.object(at: indexPath) {
      cell.textLabel?.text = mention.text
      cell.detailTextLabel?.text = "popularity: \(mention.popularity)"
    }
    return cell
  }
  
   // MARK: - Navigation
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "Search Mention" {
        if let vc = segue.destination as? HashtagAndUserTableViewController,
          let cell = sender as? UITableViewCell {          
          vc.searchText = cell.textLabel?.text
        }
      }
    }
}
