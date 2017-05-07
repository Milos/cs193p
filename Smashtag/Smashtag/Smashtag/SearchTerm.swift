//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/4/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import CoreData

class SearchTerm: NSManagedObject {
  
  class func findOrCreateQuery(query: String, in context: NSManagedObjectContext) throws -> SearchTerm
  {
    // find query
    let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
    
    request.predicate = NSPredicate(format: "text = %@", query)
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 { // query has been found
        assert(matches.count == 1, "SearchTerm.findOrCreateQuery - database inconcistency")
        return matches[0]
      }
    } catch {
      throw error
    }
    
    // create searchTerm
    let searchTerm = SearchTerm(context: context)
    searchTerm.text = query.lowercased()
    return searchTerm
  }
}
