//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Milos Menicanin on 5/7/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import Foundation


struct RecentSearches
{
  private static let defaults = UserDefaults.standard
  
  private struct Constants {
    static let key = "searchedTerms"
    static let limit = 100
  }
  
  static var searches: [String] {
    return defaults.object(forKey: Constants.key) as? [String] ?? []
  }
  
//  static func add(_ query: String) {
//    var newArray = searches
//    
//    // case insesitive and unique
//    func storeQueryToArray(_ query: String) {
//      // ignore if array has hit its limit, or if the last element in the array is the same as the query
//      guard newArray.count <= Constants.limit, query != newArray.first  else { return }
//      
//      if searches.count == Constants.limit {
//        newArray.removeFirst()
//      }
//      newArray.insert(query, at: 0)
//    }
//    // Store new query in array
//    storeQueryToArray(query)
//    
//    // update UserDefaults
//    defaults.set(newArray, forKey: Constants.key)
//  }
  
  
  static func add(_ query: String) {
    var newArray = searches.filter { query.caseInsensitiveCompare($0) != .orderedSame }
    newArray.insert(query, at: 0)
    while newArray.count > Constants.limit {
      newArray.removeLast()
    }
    defaults.set(newArray, forKey: Constants.key)
  }
  
  static func remove(at index: Int) {
    var newArray = searches
    newArray.remove(at: index)
    defaults.set(newArray, forKey: Constants.key)
  }
  
}
