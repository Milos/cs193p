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
      return Double(display.text!)!
    }
    set {
        display.text = brain.formatDisplay(newValue)
        history.text = brain.description + (brain.resultIsPending ? " ..." : " =")
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

    displayValue = brain.result!
    
  }
  @IBAction func clear(_ sender: UIButton) {
    brain.clear()
    display.text = "0"
    history.text = ""
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
    }
  }
  
  
}

