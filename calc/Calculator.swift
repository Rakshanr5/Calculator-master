//
//  Calculator.swift
//  calc
//
//  Created by Raksha Nair on 28/03/24.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case divisionByZero
    case moduloByZero
    case invalidExpression
    case invalidCharacter
}

class Calculator {
    private let precedence: [Character: Int] = ["+": 1, "-": 1, "*": 2, "/": 2, "%": 2, "x": 2, "~": 3]

    private func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }

    private func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }

    private func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }

    private func divide(_ a: Int, _ b: Int) throws -> Int {
        if b != 0 {
            return a / b
        } else {
            throw CalculatorError.divisionByZero // Throw divisionByZero error if b is zero
        }
    }

    private func modulo(_ a: Int, _ b: Int) throws -> Int {
        if b != 0 {
            return a % b
        } else {
            throw CalculatorError.moduloByZero // Throw moduloByZero error if b is zero
        }
    }
    
    private func negate(_ a: Int) -> Int {
        return -a
    }

    private func performOperation(_ a: Int, _ b: Int, _ op: Character) throws -> Int {
        switch op {
        case "+": return add(a, b)
        case "-": return subtract(a, b)
        case "*": return multiply(a, b)
        case "/": return try divide(a, b)
        case "%": return try modulo(a, b)
        case "x": return multiply(a, b)
        default:
            throw CalculatorError.invalidCharacter
        }
    }
    
    private func performUnaryOperation(_ a: Int, _ op: Character) throws -> Int {
        switch op {
        case "~": return negate(a)
        default:
            throw CalculatorError.invalidCharacter
        }
    }

    func calculate(_ expression: String) throws -> String {
        // Convert the expression string into an array of characters
        let expressionArray = expression.split(separator: " ").map { String($0) }

        do {
            // Initialize stacks for numbers and operators
            var numberStack = [Int]()
            var operatorStack = [Character]()

            // Iterate through components of the expression
            for (index, component) in expressionArray.enumerated() {
                if index % 2 == 0 { // Even indices should contain numbers
                    guard let number = Int(component) else {
                        print("Error: Invalid input")
                        exit(EXIT_FAILURE)
                    }
                    // If the component is a number, append it to the number stack
                    numberStack.append(number)
                } else { // Odd indices should contain operators
                    guard let char = component.first, component.count == 1 else {
                        throw CalculatorError.invalidCharacter
                    }
                    switch char {
                    case "+", "-", "*", "/", "%", "x":
                        // Check if the previous component was also an operator
                        if let lastOp = operatorStack.last,
                           let lastOpPrecedence = precedence[lastOp],
                           let currentOpPrecedence = precedence[char],
                           lastOpPrecedence >= currentOpPrecedence {
                            let b = numberStack.removeLast()
                            let a = numberStack.removeLast()
                            let result = try performOperation(a, b, lastOp)
                            numberStack.append(result)
                            operatorStack.removeLast()
                        }
                        operatorStack.append(char)
                    case "~":
                        operatorStack.append(char)
                    default:
                        throw CalculatorError.invalidCharacter
                    }
                }
            }

            // Perform remaining operations
            while let op = operatorStack.last {
                if op == "~" {
                    let a = numberStack.removeLast()
                    let result = try performUnaryOperation(a, op)
                    numberStack.append(result)
                } else {
                    let b = numberStack.removeLast()
                    let a = numberStack.removeLast()
                    let result = try performOperation(a, b, op)
                    numberStack.append(result)
                }
                operatorStack.removeLast()
            }

            // Return the result
            guard let result = numberStack.first else {
                throw CalculatorError.invalidExpression
            }
            return String(result)
        } catch {
            // Log the error and exit with a non-zero status
            print("Error: \(error)")
            exit(EXIT_FAILURE)
        }
    }
}





















