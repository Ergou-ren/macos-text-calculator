import Foundation

public struct ParsePreviewFormatter {
    public init() {}

    public func format(_ expression: Expression) -> String {
        switch expression {
        case .number(let value):
            return DecimalDisplayFormatter().format(value)
        case .unaryMinus(let expression):
            return "-\(format(expression))"
        case .binary(let op, let lhs, let rhs):
            return "(\(format(lhs)) \(op.rawValue) \(format(rhs)))"
        case .function(let function, let arguments):
            let formattedArguments = arguments.map(format).joined(separator: ", ")
            return "\(function.rawValue)(\(formattedArguments))"
        }
    }
}

public struct DecimalDisplayFormatter {
    public init() {}

    public func format(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        if !number.doubleValue.isFinite {
            return "overflow"
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        formatter.usesGroupingSeparator = false
        formatter.decimalSeparator = "."

        return formatter.string(from: number) ?? number.stringValue
    }
}
