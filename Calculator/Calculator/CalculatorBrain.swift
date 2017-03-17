//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Milos Menicanin on 2/25/17.
//  Copyright © 2017 Milos Menicanin. All rights reserved.
//

import Foundation


struct CalculatorBrain: CustomStringConvertible {
  
  typealias Operand = (value: Double, text: String)
  
  private var accumulator: Operand?
  
  private var internalSequence = [OperationSequenceItem]()
  
  private struct OperationSequenceItem {
    var operand: Operand?
    var symbol: String?
  }
  
  
  private enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binarryOperation((Double, Double) -> Double)
    case equals
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
    "-" : Operation.binarryOperation({ $0 - $1 }),
    "mod" : Operation.binarryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
    "=" : Operation.equals,
    "Rand": Operation.random
  ]
  
  mutating func performOperation(_ symbol: String) {
    if let operation = operations[symbol] {
      internalSequence.append(OperationSequenceItem.init(operand: nil, symbol: symbol))
      
      switch operation {
      case .constant(let value):
        accumulator = (value, "\(symbol)")
        
      case .unaryOperation(let function):
        if accumulator != nil {
          accumulator = (function(accumulator!.value), "\(symbol)(\(accumulator!.text))")
          
        }
      case .binarryOperation(let function):
        if accumulator != nil {
          if resultIsPending {
            performPendingBinaryOperation() // 5 + 5 +   (10)
          }
          pendingBinaryOperation = PendingBinaryOperation.init(function: function, firstOperand: accumulator!, mathematicalSymbol: symbol)
          accumulator = nil
        }
        
      case .equals:
        performPendingBinaryOperation()
      case .random:
        setOperand(random())
      }
    }
  }
  
  private func random() -> Double{
    return Double(arc4random()) / Double(UINT32_MAX)
  }
  
  private mutating func performPendingBinaryOperation()
  {
    if pendingBinaryOperation != nil && accumulator != nil {
      accumulator = pendingBinaryOperation?.perform(with: accumulator!)
      pendingBinaryOperation = nil
    }
    
  }
  
  private var pendingBinaryOperation: PendingBinaryOperation?
  
  private struct PendingBinaryOperation {
    let function: (Double,Double) -> Double
    let firstOperand: Operand
    let mathematicalSymbol:String
    
    func perform(with secondOperand: Operand) -> Operand {
      return (function(firstOperand.value, secondOperand.value), "\(firstOperand.text) \(mathematicalSymbol) \(secondOperand.text)")
      
    }
    
  }
  
  mutating func setOperand(_ operand: Double) {
    setOperand((operand, String(formatDisplay(operand))))
  }
  
  mutating func setOperand(_ operand: Operand) {
    accumulator = (operand)
    internalSequence.append(OperationSequenceItem.init(operand: accumulator, symbol: nil))
    //    for item in internalSequence {
    //      print("item.operand \(item.operand), item.symbol \(item.symbol)")
    //    }
  }
  
  var variables = [String: Double]()
  
  mutating func setOperand(variable named: String) {
    accumulator = (variables[named] ?? 0, named)
    internalSequence.append(OperationSequenceItem(operand: accumulator, symbol: nil))
  }
  
  func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
    var brain = CalculatorBrain()
    if variables != nil {
      brain.variables = variables! // copy
    }
    let sequence = internalSequence
    for item in sequence {
      if var operand = item.operand {
        if let newValue = variables?[operand.text] { // value of M
          operand.value = newValue
        }
        brain.setOperand(operand)
      }
      else if let symbol = item.symbol {
        brain.performOperation(symbol)
      }
    }
    return (brain.result, brain.resultIsPending, brain.description)
  }
  
  mutating func clear() {
    accumulator = nil
    pendingBinaryOperation = nil
    variables.removeAll()
    internalSequence.removeAll()
  }
  
  mutating func undo() {
    if internalSequence.count > 0 {
      internalSequence.removeLast()
    }
  }
  
  var result: Double?  {
    return accumulator?.value ?? pendingBinaryOperation?.firstOperand.value
  }
  
  var resultIsPending: Bool {
    return pendingBinaryOperation != nil
  }
  
  var description: String {
    if resultIsPending {
      if accumulator != nil {
        if accumulator!.text != String(accumulator!.value) {
          //          print("text != String(value)")
          return "\(pendingBinaryOperation!.firstOperand.text) \(pendingBinaryOperation!.mathematicalSymbol) \(accumulator!.text)"
        }
        
      }
      //      print("pendingBinaryOperation!.firstOperand.text \(pendingBinaryOperation!.firstOperand.text)")
      return "\(pendingBinaryOperation!.firstOperand.text) \(pendingBinaryOperation!.mathematicalSymbol)"
    } else {
      return "\(accumulator?.text ?? "0")"
    }
  }
  
  // format and round number
  func formatDisplay(_ number: Double) -> String{
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 6
    var numberString = formatter.string(from: NSNumber(value: number)) ?? ""
    // add 0 at the begining
    if (numberString.characters.first == "." || numberString.characters.first == ",") {
      numberString.insert("0", at: numberString.startIndex)
    }
    return numberString
  }
  
}
