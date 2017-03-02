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
  
  var displayValue: (Double?, String) {
    get {
      return (Double(display.text!)!, history.text!)
    }
    set {
      if let number = newValue.0 {
        display.text = brain.formatDisplay(number)
      }
      history.text = brain.description + (brain.resultIsPending ? " ..." : " =")
    }
  }
  
  private var brain = CalculatorBrain()
  
  @IBAction func performOperation(_ sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      if let value = displayValue.0 {
        brain.setOperand(value)
      }
      userIsInTheMiddleOfTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    
    displayValue = brain.result
    
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

