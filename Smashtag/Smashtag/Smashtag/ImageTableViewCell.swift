//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/11/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var customImageView: UIImageView!
  
  var mediaItem: MediaItem?
  
  func setup(with item: MediaItem) {
    self.mediaItem = item
    DispatchQueue.global(qos: .userInitiated).async {
      if let data = try? Data.init(contentsOf: item.url) {
        let image = UIImage.init(data: data)
        DispatchQueue.main.async { [weak self] in
          if item.url == self?.mediaItem?.url {
            self?.customImageView.image = image
          }
        }
      }
    }
  }
}
