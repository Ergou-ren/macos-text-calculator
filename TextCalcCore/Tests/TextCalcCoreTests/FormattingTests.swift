import Foundation
import Testing
@testable import TextCalcCore

struct FormattingTests {
    private let engine = CalculatorEngine()

    @Test func fractionalFormattingUsesPolicy() throws {
        let sqrtResult = try engine.evaluate("sqrt(2)")
        let divisionResult = try engine.evaluate("1/3")

        #expect(sqrtResult.displayText == "1.4142135624")
        #expect(divisionResult.displayText == "0.3333333333")
    }
}
