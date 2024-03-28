//
//  main.swift
//  calc
//
//  Created by Raksha Nair on 28/03/24.
//  
//

import Foundation

let expression = CommandLine.arguments.dropFirst().joined(separator: " ")
let calculator = Calculator()
do {
    let result = try calculator.calculate(expression)
    print(result)
} catch CalculatorError.divisionByZero {
    print("Cannot divide by zero")
} catch CalculatorError.moduloByZero {
    print("Cannot modulo by zero")
} catch CalculatorError.invalidCharacter {
    print("Invalid character in expression")
} catch CalculatorError.invalidExpression {
    print("Invalid expression")
} catch {
    print("An unexpected error occurred")
}

