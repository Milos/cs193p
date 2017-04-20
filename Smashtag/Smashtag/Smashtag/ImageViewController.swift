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
  
  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
      imageView.sizeToFit() // size it's frame to fit the image inside it
      scrollView?.contentSize = imageView.frame.size
      adjustImageView()
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
    } else {
      adjustImageView()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    adjustImageView()
  }
  
}

extension ImageViewController : UIScrollViewDelegate
{
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}

// Auto fit image view in the center
extension ImageViewController {
  private var offset: CGPoint {
    if scrollView != nil {
      var x = scrollView.bounds.origin.x // 0
      var y = scrollView.bounds.origin.y // 0
      
      if scrollView.contentSize.width > scrollView.frame.width { // image wider then superview width
        x = (scrollView.contentSize.width - scrollView.frame.width) / 2
      } else {
        y = (scrollView.contentSize.height - scrollView.frame.height) / 2
      }
      
      return CGPoint.init(x: x, y: y)
    } else {
      
    }
    return CGPoint.zero
  }
  
  private var aspectRatio: CGFloat {
    if let image = image {
      return image.size.width / image.size.height
    }
    return 1
  }
  
  private var zoomScale: CGFloat {
    if let scrollView = scrollView, let image = image {
      let zoomToWidth = scrollView.frame.width / image.size.width
      let zoomToHeight = (scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom) / image.size.height
      
      if aspectRatio < scrollView.frame.width / scrollView.frame.height {   // image wider then superview
        scrollView.minimumZoomScale = zoomToHeight
        scrollView.maximumZoomScale = zoomToWidth * 2
        return zoomToWidth
      } else {
        scrollView.minimumZoomScale = zoomToWidth
        scrollView.maximumZoomScale = zoomToHeight * 2
        return zoomToHeight
      }
    }
    return 1
  }
  
  fileprivate func adjustImageView() {
    imageView.sizeToFit()
    scrollView?.contentSize = imageView.frame.size
    scrollView?.zoomScale = zoomScale
    scrollView?.contentOffset = offset
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    adjustImageView()
  }
  
}
