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
    case mention(Twitter.Mention)
    case media(Twitter.MediaItem)
    
    var associatedValue: Any {
      switch self {
      case .media(let mediaItem):
        return mediaItem
      case .mention(let mention):
        return mention
      }
    }
  }
  
  private enum SectionType: String {
    case image = "Images mentions"
    case userMention = "User mentions"
    case url = "URL mentions"
    case hashtag = "Hashtags mentions"
  }
  
  private struct Section {
    var contents: [SectionContent]
    var type: SectionType
  }
  
  private var sections = [Section]()
  private let sectionTypes: [SectionType] = [.hashtag, .image, .url, .userMention]
  
  func prepareInternalData(){
    sections.removeAll()
    var sectionData = [SectionContent]()
    
    for sectionsType in sectionTypes {
      
      switch sectionsType {
      case .hashtag:
        if let hashtags = tweet?.hashtags, hashtags.count > 0 {
          for hashtag in hashtags {
            sectionData = [SectionContent.mention(hashtag)]
          }
          sections.append(Section.init(contents: sectionData, type: .hashtag))
        }
      case .url:
        if let urls = tweet?.urls, urls.count > 0 {
          for url in urls {
            sectionData = [SectionContent.mention(url)]
          }
          sections.append(Section.init(contents: sectionData, type: .url))
        }
      case .userMention:
        if let userMentions = tweet?.userMentions, userMentions.count > 0 {
          for userMention in userMentions {
            sectionData = [SectionContent.mention(userMention)]
          }
          sections.append(Section.init(contents: sectionData, type: .userMention))
        }
      case .image:
        if let images = tweet?.media, images.count > 0 {
          for image in images {
            sectionData = [SectionContent.media(image)]
          }
          sections.append(Section.init(contents: sectionData, type: .image))
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
    return sections[section].type.rawValue
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if sections[indexPath.section].type == .image {
      if let media = sections[indexPath.section].contents[indexPath.row].associatedValue as? MediaItem {
        return view.frame.size.width / CGFloat(media.aspectRatio)
      }
    }
    return UITableViewAutomaticDimension
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //    var cell: UITableViewCell
    //
    //    let data = sections[indexPath.section].contents[indexPath.row]
    //    switch data {
    //    case .media(let mediaItem):
    //      cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Detail Media Cell", for: indexPath)
    //      (cell as! ImageTableViewCell).setup(with: mediaItem)
    //    case .mentions(let mention):
    //      cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Detail Text Cell", for: indexPath)
    //      cell.textLabel?.text = mention.keyword
    //    }
    //
    return cell
    
    
    
  }
  
  
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
