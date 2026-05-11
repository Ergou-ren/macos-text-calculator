import Foundation

public struct Evaluator {
    public init() {}

    public func evaluate(_ expression: Expression) throws -> Decimal {
        switch expression {
        case .number(let value):
            return value
        case .unaryMinus(let nested):
            return try evaluate(nested) * Decimal(-1)
        case .binary(let op, let lhs, let rhs):
            return try evaluateBinary(op: op, lhs: lhs, rhs: rhs)
        case .function(let function, let arguments):
            return try evaluateFunction(function, arguments: arguments)
        }
    }

    private func evaluateBinary(op: BinaryOperator, lhs: Expression, rhs: Expression) throws -> Decimal {
        let lhsValue = try evaluate(lhs)
        let rhsValue = try evaluate(rhs)

        switch op {
        case .add:
            return lhsValue + rhsValue
        case .subtract:
            return lhsValue - rhsValue
        case .multiply:
            return lhsValue * rhsValue
        case .divide:
            guard rhsValue != 0 else {
                throw CalculationError.divideByZero
            }
            return lhsValue / rhsValue
        case .power:
            return try power(base: lhsValue, exponent: rhsValue)
        }
    }

    private func evaluateFunction(_ function: BuiltinFunction, arguments: [Expression]) throws -> Decimal {
        switch function {
        case .pow:
            guard arguments.count == 2 else {
                throw CalculationError.invalidSyntax("pow expects 2 arguments")
            }
            return try power(base: evaluate(arguments[0]), exponent: evaluate(arguments[1]))
        case .sqrt:
            guard arguments.count == 1 else {
                throw CalculationError.invalidSyntax("sqrt expects 1 argument")
            }
            let value = try evaluate(arguments[0])
            guard value >= 0 else {
                throw CalculationError.domainError("square root of a negative value")
            }
            let result = Foundation.sqrt(NSDecimalNumber(decimal: value).doubleValue)
            guard result.isFinite else {
                throw CalculationError.overflow
            }
            return Decimal(result)
        }
    }

    private func power(base: Decimal, exponent: Decimal) throws -> Decimal {
        let result = Foundation.pow(NSDecimalNumber(decimal: base).doubleValue, NSDecimalNumber(decimal: exponent).doubleValue)
        guard result.isFinite else {
            throw CalculationError.overflow
        }
        return Decimal(result)
    }
}
