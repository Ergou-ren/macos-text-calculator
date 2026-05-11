import Foundation

public struct CalculatorEngine {
    private let normalizer: Normalizer
    private let evaluator: Evaluator
    private let displayFormatter: DecimalDisplayFormatter

    public init(
        normalizer: Normalizer = Normalizer(),
        evaluator: Evaluator = Evaluator(),
        displayFormatter: DecimalDisplayFormatter = DecimalDisplayFormatter()
    ) {
        self.normalizer = normalizer
        self.evaluator = evaluator
        self.displayFormatter = displayFormatter
    }

    public func evaluate(_ input: String) throws -> CalculationResult {
        let normalizationResult = try normalizer.normalize(input)
        let tokens = try Tokenizer().tokenize(normalizationResult.normalizedExpression)
        var parser = Parser(tokens: tokens)
        let expression = try parser.parse()
        let value = try evaluator.evaluate(expression)
        let preview = ParsePreviewFormatter().format(expression)
        let displayText = displayFormatter.format(value)
        return CalculationResult(
            normalizedExpression: preview,
            value: value,
            displayText: displayText
        )
    }
}
