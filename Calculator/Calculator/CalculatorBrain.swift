//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Milos Menicanin on 2/25/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import Foundation


struct CalculatorBrain {
  
  private var accumulator: Double?
  
  var description = " "
  
  private enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binarryOperation((Double, Double) -> Double)
    case equals
    case clear
    case random
  }
  
  private var operations: Dictionary<String,Operation> = [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    "√" : Operation.unaryOperation(sqrt),
    "cos" : Operation.unaryOperation(cos),
    "±" : Operation.unaryOperation({ -$0 }),
    "x²" : Operation.unaryOperation({ $0 * $0 }),
    "×" : Operation.binarryOperation({ $0 * $1 }),
    "÷" : Operation.binarryOperation({ $0 / $1 }),
    "+" : Operation.binarryOperation({ $0 + $1 }),
    "−" : Operation.binarryOperation({ $0 - $1 }),
    "%" : Operation.binarryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
    "=" : Operation.equals,
    "C" : Operation.clear,
    "Rand": Operation.random
  ]
  
  mutating func performOperation(_ symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .constant(let value):
        // prevents copying the same symbol in the description one after another
        if (String(description.characters.last!) != symbol) {
          description += symbol
          pendingDescription = true
          accumulator = value
        }
        
      case .unaryOperation(let function):
        if accumulator != nil {
          if (symbol == "x²") {
            description = "(\(description))²"
          } else {
            if (pendingBinaryOperation != nil) {
              
              description += symbol + "(\(formatDisplay(accumulator!)))"
              pendingDescription = true
            }else {
              description = symbol + "(\(description))"
            }
          }
          accumulator = function(accumulator!)
        }
      case .binarryOperation(let function):
        print("accumulator:  \(accumulator)")
        if accumulator != nil { //checks if there are operands to work with
          description += symbol
          performPendingBinaryOperation()
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, mathematicalSymbol: symbol)
          accumulator = nil
        }
        
      case .equals:
        performPendingBinaryOperation()
      case .clear:
        clear()
      case .random:
        setOperand(random())
      }
    }
  }
  
  private func random() -> Double{
    return Double(arc4random()) / Double(UINT32_MAX)
  }
  private mutating func performPendingBinaryOperation() {
    if pendingBinaryOperation != nil && accumulator != nil {
            if (pendingDescription) {
                // add nothing to description
                pendingDescription = false
            } else {
              description += formatDisplay(accumulator!) // not true for (g): 7 + 9√=
            }
      
      accumulator = pendingBinaryOperation!.perform(with: accumulator!)
      print("description\(description)")
      
      pendingBinaryOperation = nil
    }
  }
  private var pendingBinaryOperation: PendingBinaryOperation?
  private var pendingDescription = false
  
  private struct PendingBinaryOperation {
    let function: (Double,Double) -> Double
    let firstOperand: Double
    let mathematicalSymbol:String
    
    func perform(with secondOperand: Double) -> Double {
      return function(firstOperand, secondOperand)
    }
  }
  
  mutating func setOperand(_ operand: Double) {
    accumulator = operand
    print("SetOperand Description: \(description)")
    
    if pendingBinaryOperation == nil {
      description = formatDisplay(operand)
    }
  }
  
  mutating func clear() {
    accumulator = 0 // ili nil pa dodati clear u view-u.
    description = " "
    pendingBinaryOperation = nil
    
  }
  var result: (Double?,String)  {
    return (accumulator, description)
  }
  
  var resultIsPending: Bool {
    return pendingBinaryOperation != nil
  }
  
  // format and round number
  func formatDisplay(_ number: Double) -> String{
    let formatter = NumberFormatter()
    formatter.roundingMode = NumberFormatter.RoundingMode.down
    formatter.maximumFractionDigits = 6
    return formatter.string(from: NSNumber(value: number)) ?? ""
  }
  
}
