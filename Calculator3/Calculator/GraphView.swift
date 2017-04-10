//
//  GraphView.swift
//  axesDrawer
//
//  Created by Milos Menicanin on 3/14/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
  func calculateY(xValue x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
  
  @IBInspectable
  var scale: CGFloat = 40 { didSet { setNeedsDisplay() } } // 40 points per unit
  
  @IBInspectable
  var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var origin: CGPoint! { didSet { setNeedsDisplay() } }
  
  
  var axesCenter: CGPoint {
    get {
      return origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
    }
    set {
      origin = newValue
    }
  }
  
  // Gesture Handlers
  func handlePinchGesture(_ pinchGesture: UIPinchGestureRecognizer) {
    scale *= pinchGesture.scale
    pinchGesture.scale = 1
  }
  
  func handleTapGesture(_ tapGesture: UIPanGestureRecognizer) {
    let touchPoint = tapGesture.location(in: self)
    axesCenter = CGPoint(x: touchPoint.x, y: touchPoint.y)
  }
  
  func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
    switch panGesture.state {
    case .changed, .ended:
      let translation = panGesture.translation(in: self)
      origin = CGPoint(x: self.axesCenter.x + translation.x, y: axesCenter.y + translation.y)
      panGesture.setTranslation(CGPoint.zero, in: self)
    default:
      break
    }
  }
  
  weak var delegate: GraphViewDataSource?
  
  private var drawer = AxesDrawer()
  
  // pass function
  private func drawGraph() {
    let path = UIBezierPath()
    var firstLoop = true
    
    for xPoint in stride(from: bounds.minX, to: bounds.maxX, by: 2) {
      let xValue = getXValue(xPoint)
      if let yValue = delegate?.calculateY(xValue: xValue) {
        if (!yValue.isNormal && !yValue.isZero) {
          firstLoop = true
          continue
        }
        
        let yPoint = getYPosition(yValue)
        
        let point = CGPoint(x: xPoint, y: yPoint)
        
        if firstLoop {
          path.move(to: point)
          firstLoop = false
        } else {
          path.addLine(to: point)
        }
        path.move(to: point)
        
      }
    }
    
    color = UIColor.red
    color.set()
    path.stroke()
    
  }
  
  override func draw(_ rect: CGRect) {
    drawGraph()
    drawer.drawAxes(in: self.bounds, origin: axesCenter, pointsPerUnit: scale)
    
  }
  
  private func getXValue(_ xPosition: CGFloat) -> CGFloat{
    return (xPosition - axesCenter.x) / scale
  }
  private func getYPosition(_ yValue: CGFloat) -> CGFloat{
    return axesCenter.y - yValue * scale
  }
  
  
  
}
