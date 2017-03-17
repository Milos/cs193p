//
//  GraphView.swift
//  axesDrawer
//
//  Created by Milos Menicanin on 3/14/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
  func calculateY(_ graphView: GraphView, xValue x: CGFloat) -> CGFloat?
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
  
  // Gesture Handlers (should be private)
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
    //    var paths = [UIBezierPath]()
    let path = UIBezierPath()
    var firstLoop = true
    
    for xPoint in stride(from: bounds.minX, to: bounds.maxX, by: 2) {
      let xValue = getXValue(xPoint)
      if let yValue = delegate?.calculateY(self, xValue: xValue) {
        if (!yValue.isNormal && !yValue.isZero) {   //  ( t ili N = T => N)
          firstLoop = true
          continue
        }
        
        // x je isti a y ide gore/dole, za svako PI
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
    
    // circle in center
    //    let path = UIBezierPath(arcCenter: axesCenter, radius: 4, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
    //    color.set()
    //    path.fill()
    //    path.stroke()
    
  }
  
  
  private func generatePaths() -> [UIBezierPath] {
    
    var paths = [UIBezierPath]()
    
    var firstLoop = true
    var path = UIBezierPath()
    paths.append(path)
    
    for xPoint in stride(from: bounds.minX, to: bounds.maxX, by: 2) {
      if let yValue = delegate?.calculateY(self, xValue: getXValue(CGFloat(xPoint))) {
        print (yValue)
        let yPoint = getYPosition(yValue)
        let point = CGPoint.init(x: xPoint, y: yPoint)
        guard checkValidation(of: point) else {
          if !firstLoop {
            path = UIBezierPath()
            paths.append(path)
            firstLoop = true
          }
          continue
        }
        if firstLoop {
          path.move(to: point)
          firstLoop = false
        } else {
          path.addLine(to: point)
        }
      }
    }
    
    return paths
  }
  
  private func checkValidation(of point: CGPoint) -> Bool {
    return self.bounds.contains(point)
  }
  
  //
  //  override func draw(_ rect: CGRect) {
  //    print("draw() called")
  //    drawer.drawAxes(in: self.bounds, origin: axesCenter, pointsPerUnit: scale)
  //    color.set()
  //    let paths = generatePaths()
  //    for path in paths {
  //      path.stroke()
  //    }
  //  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // x=0,y=1
  private func getXValue(_ xPosition: CGFloat) -> CGFloat{
    return (xPosition - axesCenter.x) / scale
  }
  private func getYPosition(_ yValue: CGFloat) -> CGFloat{
    return axesCenter.y - yValue * scale
  }
  
  
  
}
