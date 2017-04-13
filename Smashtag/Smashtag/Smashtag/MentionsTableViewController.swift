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
      print("tweet: \(tweet?.description)")
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
    case image
    case userMention = "User mentions"
    case url = "URL mentions"
    case hashtag = "Hashtags mentions"
  }
  
  private struct Section {
    var headline: String?
    var contents: [SectionContent]
    var type: SectionType
  }
  
  private var sections = [Section]()
  private let sectionTypes: [SectionType] = [.hashtag, .image, .url, .userMention]
  
  
  func prepareInternalData() {
    sections.removeAll()
    
    func appendSectionData(title: String, mentions: [Mention], type: SectionType) {
      var sectionData = [SectionContent]()
      for mention in mentions {
        sectionData.append(SectionContent.mention(mention))
      }
      if sectionData.count > 0 {
        sections.append(Section.init(headline: title, contents: sectionData, type: type))
      }
    }
    
    if let tweet = tweet {
      var mediaData = [SectionContent]()
      for media in tweet.media {
        mediaData.append(SectionContent.media(media))
      }
      sections.append(Section.init(headline: nil, contents: mediaData, type: .image))
      
      appendSectionData(title: SectionType.userMention.rawValue, mentions: tweet.userMentions, type: .userMention)
      appendSectionData(title: SectionType.url.rawValue, mentions: tweet.urls, type: .url)
      appendSectionData(title: SectionType.hashtag.rawValue, mentions: tweet.hashtags, type: .hashtag)
    }
  }
  
  func updateUI() {
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    print("sections.count \(sections.count)")
    return sections.count
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].contents.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].headline
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
        var cell: UITableViewCell
        let data = sections[indexPath.section].contents[indexPath.row] // row (SectionContent)
    
        switch data {
        case .media(let mediaItem):
          print(mediaItem.url.description)
          cell = tableView.dequeueReusableCell(withIdentifier: "Media Cell", for: indexPath)
          (cell as! ImageTableViewCell).setup(with: mediaItem)
//          let data = try? Data(contentsOf: mediaItem.url)
//          if let imageData = data {
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.imageView?.image = UIImage(data: imageData)
//          }
          
        case .mention(let mention):
          print(mention.keyword)
          cell = tableView.dequeueReusableCell(withIdentifier: "Mention Cell", for: indexPath)
          cell.textLabel?.text = mention.keyword
        }
    //
    return cell
  }
    
  
   // MARK: - Navigation
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
  
  
}
