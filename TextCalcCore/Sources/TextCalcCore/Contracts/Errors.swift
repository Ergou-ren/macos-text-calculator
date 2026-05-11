import Foundation

public enum CalculationError: Error, Equatable, LocalizedError {
    case unsupportedInput(String)
    case invalidSyntax(String)
    case domainError(String)
    case divideByZero
    case overflow

    public var errorDescription: String? {
        switch self {
        case .unsupportedInput(let input):
            return "Unsupported input: \(input)"
        case .invalidSyntax(let reason):
            return "Invalid syntax: \(reason)"
        case .domainError(let reason):
            return "Math domain error: \(reason)"
        case .divideByZero:
            return "Math error: division by zero"
        case .overflow:
            return "Math error: value is out of supported range"
        }
    }
}
