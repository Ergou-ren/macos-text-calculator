import AppKit
import Observation
import TextCalcCore

@Observable
final class CalculatorViewModel {
    var input: String = ""
    var preview: String?
    var result: String?
    var errorMessage: String?

    private let engine = CalculatorEngine()

    func evaluate() -> CalculationResult? {
        do {
            let calculation = try engine.evaluate(input)
            preview = calculation.normalizedExpression
            result = calculation.displayText
            errorMessage = nil
            return calculation
        } catch {
            preview = nil
            result = nil
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func clear() {
        input = ""
        preview = nil
        result = nil
        errorMessage = nil
    }

    func copyLatestResult() {
        guard let result else {
            return
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(result, forType: .string)
    }
}
