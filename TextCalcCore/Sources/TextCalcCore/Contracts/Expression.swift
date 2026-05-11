import Foundation

public enum BinaryOperator: String, Equatable {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case power = "^"
}

public enum BuiltinFunction: String, Equatable {
    case pow
    case sqrt
}

public indirect enum Expression: Equatable {
    case number(Decimal)
    case unaryMinus(Expression)
    case binary(BinaryOperator, Expression, Expression)
    case function(BuiltinFunction, [Expression])
}
