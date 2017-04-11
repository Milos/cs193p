//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/10/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
  
  
  // MARK: Model
  
  var tweet: Twitter.Tweet? {
    didSet {
      prepareInternalData()
      title = tweet?.user.name
      updateUI()
    }
  }
  
  private enum SectionContent {
    case mentions([Twitter.Mention])
    case media([Twitter.MediaItem])
  }
  
  private enum SectionType {
    case image(String)
    case userMention(String)
    case url(String)
    case hashtag(String)
  }
  
//  private enum SectionType: String {
//    case image = "Images mentions"
//    case userMention = "User mentions"
//    case url = "URL mentions"
//    case hashtag = "Hashtags mentions"
//  }
  
  private struct Section {
    var contents: [SectionContent]
    var headline: String
//    var type: SectionType
  }
  
  private let sectionsTypes = [
    SectionType.hashtag("Hashtags mentions"),
    .url("Url mentions"),
    .userMention("Users mentions"),
    .image("Images")
  ]
  
  private var sections = [Section]()
  
  private func prepareInternalData(){
    sections.removeAll()
    
    
    for sectionsType in sectionsTypes {

      switch sectionsType {
      case .hashtag(let value):
        if let hashtags = tweet?.hashtags, hashtags.count > 0 {
          sections.append(Section.init(contents: [SectionContent.mentions(hashtags)], headline: value))
        }
      case .url(let value):
        if let urls = tweet?.urls, urls.count > 0 {
          sections.append(Section.init(contents: [SectionContent.mentions(urls)], headline: value))
        }
      case .userMention(let value):
        if let userMentions = tweet?.userMentions, userMentions.count > 0 {
          sections.append(Section.init(contents: [SectionContent.mentions(userMentions)], headline: value))
        }
      case .image(let value):
        if let images = tweet?.media, images.count > 0 {
          sections.append(Section.init(contents: [SectionContent.media(images)], headline: value))
        }
        
      }
      
    }
  }
  
  func updateUI() {
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].contents.count
  }
  
  func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String {
    return sections[section].headline
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    var b = sectionsTypes[0]
    return 0.0
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "headline"
  }
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
