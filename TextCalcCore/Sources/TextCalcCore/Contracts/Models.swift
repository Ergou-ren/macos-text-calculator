import Foundation

public struct CalculationResult: Equatable {
    public let normalizedExpression: String
    public let value: Decimal
    public let displayText: String

    public init(normalizedExpression: String, value: Decimal, displayText: String) {
        self.normalizedExpression = normalizedExpression
        self.value = value
        self.displayText = displayText
    }
}

public struct NormalizationResult: Equatable {
    public let normalizedExpression: String

    public init(normalizedExpression: String) {
        self.normalizedExpression = normalizedExpression
    }
}
