//
//  ImageUIViewController.swift
//  Smashtag
//
//  Created by Milos Menicanin on 4/13/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  
  
  // MARK: Model
  
  var imageURL: URL? {
    didSet {
      image = nil
      if view.window != nil { // if it's on screen
        fetchImage()
      }
    }
  }
  
  private func fetchImage() {
    if let url = imageURL {
      
      spinner.startAnimating()
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        let urlContents = try? Data(contentsOf: url) // if can't get it, don't show it
        if let imageData = urlContents, url == self?.imageURL {
          DispatchQueue.main.async {
            self?.image = UIImage(data: imageData)
          }
          
        }
      }
    }
  }
  
  private var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
      imageView.sizeToFit() // size it's frame to fit the image inside it
      scrollView?.contentSize = imageView.frame.size
      spinner?.stopAnimating()
    }
  }
  
  fileprivate var imageView = UIImageView() // upper-left corner of it's super view
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      
      scrollView.delegate = self
      scrollView.minimumZoomScale = 0.03
      scrollView.maximumZoomScale = 1.0
      scrollView.contentSize = imageView.frame.size // image size = content size
      scrollView.addSubview(imageView)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if image == nil {
      fetchImage()
    }
  }
  
}

extension ImageViewController : UIScrollViewDelegate
{
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
