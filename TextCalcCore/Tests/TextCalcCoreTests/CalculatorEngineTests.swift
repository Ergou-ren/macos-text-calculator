import Testing
@testable import TextCalcCore

struct CalculatorEngineTests {
    private let engine = CalculatorEngine()

    @Test func sumPromptNormalizesAndCalculates() throws {
        let result = try engine.evaluate("1 2 3 4 5 6 7 这几个数字求和")
        #expect(result.displayText == "28")
        #expect(result.normalizedExpression == "((((((1 + 2) + 3) + 4) + 5) + 6) + 7)")
    }

    @Test func directExpressionCalculates() throws {
        let result = try engine.evaluate("(12+5)*3")
        #expect(result.displayText == "51")
    }

    @Test func squareAndPowerPromptsCalculate() throws {
        let powerResult = try engine.evaluate("2 的 8 次方")
        let squareResult = try engine.evaluate("9 的平方")
        #expect(powerResult.displayText == "256")
        #expect(squareResult.displayText == "81")
    }

    @Test func squareRootPromptsCalculate() throws {
        let result = try engine.evaluate("81 开平方")
        #expect(result.displayText == "9")
    }

    @Test func sequentialArithmeticCalculates() throws {
        let result = try engine.evaluate("120 减去 35 再乘 2")
        #expect(result.displayText == "170")
    }

    @Test func chainedArithmeticWithImplicitSubjectCalculates() throws {
        let result = try engine.evaluate("45先加5再除以10")
        #expect(result.displayText == "5")
        #expect(result.normalizedExpression == "((45 + 5) / 10)")
    }

    @Test func unsupportedInputFailsClearly() {
        do {
            _ = try engine.evaluate("把 3 公里换算成米")
            Issue.record("Expected unsupported input error")
        } catch let error as CalculationError {
            #expect(error == .unsupportedInput("把 3 公里换算成米"))
        } catch {
            Issue.record("Expected CalculationError, got \(error)")
        }
    }

    @Test func divideByZeroFailsClearly() {
        do {
            _ = try engine.evaluate("1/0")
            Issue.record("Expected divide-by-zero error")
        } catch let error as CalculationError {
            #expect(error == .divideByZero)
        } catch {
            Issue.record("Expected CalculationError, got \(error)")
        }
    }

    @Test func negativeSquareRootFailsClearly() {
        do {
            _ = try engine.evaluate("sqrt(-1)")
            Issue.record("Expected domain error")
        } catch let error as CalculationError {
            #expect(error == .domainError("square root of a negative value"))
        } catch {
            Issue.record("Expected CalculationError, got \(error)")
        }
    }
}
