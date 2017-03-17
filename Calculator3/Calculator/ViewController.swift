//
//  ViewController.swift
//  Calculator
//
//  Created by Milos Menicanin on 2/24/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var display: UILabel!
  
  @IBOutlet weak var history: UILabel!
  
  @IBOutlet weak var variable: UILabel!
  
  var userIsInTheMiddleOfTyping = false
  
  @IBAction func touchDigit(_ sender: UIButton) {
    
    let digit = sender.currentTitle!
    
    if userIsInTheMiddleOfTyping {
      let textCurrentInDisplay = display.text!
      // check for multiple dots
      if !(textCurrentInDisplay.contains(".") && digit == "."){
        display.text = textCurrentInDisplay + digit
      }
    } else {
      if (digit == ".") {
        display.text = "0" + digit
      } else {
        display.text = digit
      }
      userIsInTheMiddleOfTyping = true
    }
  }
  
  var displayValue: Double {
    get {
      return Double(display.text!) ?? Double.nan
    }
    set {
      if newValue.isInfinite || newValue.isNaN {
          display.text = "Error"
      }else {
        display.text = brain.formatDisplay(newValue)
      }
    }
  }
  
  private var brain = CalculatorBrain()
  
  @IBAction func performOperation(_ sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    //    displayValue = brain.result!
    evaluate()
    
  }
  
  @IBAction func clear(_ sender: UIButton) {
    brain.clear()
    display.text = "0"
    history.text = ""
    variable.text = ""
    userIsInTheMiddleOfTyping = false
  }
  
  @IBAction func touchVariable(_ sender: UIButton) {
    brain.setOperand(variable: sender.currentTitle ?? "")
    display.text = sender.currentTitle ?? ""
  }
  
  @IBAction func touchToEvaluate(_ sender: UIButton) {
    brain.variables["M"] = displayValue
    variable.text = "M= \(displayValue)"
    evaluate()
  }
  
  @IBAction func backspace() {
    if userIsInTheMiddleOfTyping {
      if var text = display.text {
        text.remove(at: text.characters.index(before: text.endIndex))
        if text.isEmpty {
          text = "0"
          userIsInTheMiddleOfTyping = false
        }
        display.text = text
      }
    } else {
      brain.undo()
      evaluate()
    }
  }
  
  private func evaluate() {
    let (result, resultIsPending, description) = brain.evaluate(using: brain.variables)
    if result != nil {
      history.text = description + (resultIsPending ? " ..." : " =")
      displayValue = result!
    }
    userIsInTheMiddleOfTyping = false
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination.contents as? GraphViewController {
      vc.brain = self.brain
      
      var title = history.text!
      if title.contains("=") {
        title = title.substring(to: (title.index(before: (title.endIndex))))
        vc.navigationItem.title = "y = \(title)"
      } else {
        vc.navigationItem.title = "y = \(display.text!)"
      }
      
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    // if brain is pending should not segue to graph view
    if identifier == "graph" && brain.resultIsPending {
      return false
    }
    return true
  }
}

