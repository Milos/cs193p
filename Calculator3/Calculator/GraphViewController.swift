//
//  ViewController.swift
//  axesDrawer
//
//  Created by Milos Menicanin on 3/14/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
  
  // Show master
  override func awakeFromNib() {
    super.awakeFromNib()
    self.splitViewController?.delegate = self
  }
  
  @IBOutlet weak var graphView: GraphView! {
    didSet {
      let pinchGesture = UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.handlePinchGesture(_:)))
      graphView.addGestureRecognizer(pinchGesture)
      let panGesture = UIPanGestureRecognizer.init(target: graphView, action: #selector(graphView.handlePanGesture(_:)))
      graphView.addGestureRecognizer(panGesture)
      let tapGesture = UITapGestureRecognizer.init(target: graphView, action: #selector(graphView.handleTapGesture(_:)))
      tapGesture.numberOfTapsRequired = 2
      graphView.addGestureRecognizer(tapGesture)
      graphView.delegate = self
      updateUI()
    }
  }
  
  var brain: CalculatorBrain? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {    
    graphView?.setNeedsDisplay()
  }


}

extension UIViewController {
  var contents: UIViewController {
    if let navcon = self as? UINavigationController {
      
      return navcon.visibleViewController ?? self // ???
    }
    else {
      return self
    }
  }
}

extension GraphViewController: GraphViewDataSource {
  
  func calculateY(_ graphView: GraphView, xValue x: CGFloat) -> CGFloat? {
    if brain != nil {
      brain!.variables["M"] = Double(x)
      let (result, isPending, _) = brain!.evaluate(using: brain!.variables)
      if !isPending && result != nil {
        return CGFloat(result!)
      }
    }
    return nil
  }
}

// Show master
extension GraphViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}

