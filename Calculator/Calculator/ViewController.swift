//
//  ViewController.swift
//  Calculator
//
//  Created by Zhihong Ren on 3/6/16.
//  Copyright © 2016 Zhihong Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    var brain = calculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if (userIsInTheMiddleOfTypingNumber){
            display.text = display.text!+digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result;
        }
        else {
            displayValue = nil
        }

    }
    var displayValue: Double? {
        get{
            if display.text == nil {
                return nil
            }
            else {
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }

        set{
            if newValue == nil {
                display.text = "error input"
            }
            else {
                display.text = "\(newValue!)"
                userIsInTheMiddleOfTypingNumber = false
            }

        }
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let result = brain.performOperation(operation) {
            displayValue = result
        }
        else {
            displayValue = nil
        }

    }

    @IBAction func Clear() {
        brain.clear()
        displayValue = 0;
        userIsInTheMiddleOfTypingNumber = false
    }
}

