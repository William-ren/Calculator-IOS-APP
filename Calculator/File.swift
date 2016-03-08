//
//  File.swift
//  Calculator
//
//  Created by Zhihong Ren on 3/7/16.
//  Copyright © 2016 Zhihong Ren. All rights reserved.
//

import Foundation

class calculatorBrain  {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation (String , (Double , Double) -> Double)
        
        var description : String {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
   private var opStack = [Op]()
    
   private var knowOps = [String:Op]()
    
    init () {
        func learnOp (op: Op){
            knowOps[op.description]=op;
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt))

    }
    
    private func evaluateHelper ( ops:[Op] )-> (result: Double? , remainingOps : [Op]){
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand , remainingOps)
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluateHelper (remainingOps)
                if let operand1=op1Evaluation.result {
                    let op2Evaluation = evaluateHelper(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1 , operand2 ), op2Evaluation.remainingOps)
                    }
                }
                
            case .UnaryOperation(_, let operation):
                let opEvaluation = evaluateHelper(remainingOps)
                if let operand = opEvaluation.result {
                    return (operation(operand), opEvaluation.remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func pushOperand (operand: Double) -> Double? {
        opStack.append(Op.Operand(operand));
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let ( result, _ ) = evaluateHelper(opStack)
        return result;
    }
        
    func performOperation (symbol: String) -> Double? {
        if let operation = knowOps[symbol] {
            opStack.append(operation)
            return evaluate()
        }
        return nil
    }
    func clear () {
        opStack.removeAll()
    }
}


