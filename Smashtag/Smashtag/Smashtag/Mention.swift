//
//  Mention.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/4/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mention: NSManagedObject
{
  class func findOrCreateMention(query: String, matching mentionInfo: Twitter.Mention, in context: NSManagedObjectContext) throws -> Mention
  {
    // find mention
    let request: NSFetchRequest<Mention> = Mention.fetchRequest()
    request.predicate = NSPredicate(format: "text = %@", mentionInfo.keyword.lowercased())
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 { // mention has been found
        assert(matches.count == 1, "Mention.findOrCreateMention - database inconcistency")
        // update attributes
        matches[0].popularity += 1
        if let searchedTerm = try? SearchTerm.findOrCreateQuery(query: query, in: context) {
          matches[0].addToSearchedTerm(searchedTerm)
        }
        print("mention keyword: \(mentionInfo.keyword)")
        print("matches popularity: \(matches[0].popularity)")
        print("------")
        return matches[0]
      }
    } catch {
      throw error
    }
    
    // create mention
    let mention = Mention(context: context)
    mention.text = mentionInfo.keyword.lowercased()
    print("creating mention: \(mention.text!)")
    mention.popularity = 1
    if let searchedTerm = try? SearchTerm.findOrCreateQuery(query: query, in: context) {
      mention.addToSearchedTerm(searchedTerm)
    }
    return mention
  }
  
}
