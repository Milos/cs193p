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
