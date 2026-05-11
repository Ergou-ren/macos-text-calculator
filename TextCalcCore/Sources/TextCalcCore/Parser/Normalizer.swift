import Foundation

public struct Normalizer {
    public init() {}

    public func normalize(_ input: String) throws -> NormalizationResult {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw CalculationError.unsupportedInput(input)
        }

        if let normalized = normalizeAggregate(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if let normalized = normalizePower(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if let normalized = normalizeSquare(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if let normalized = normalizeSquareRoot(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if let normalized = normalizeSequentialArithmetic(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if let normalized = normalizeBinaryArithmetic(trimmed) {
            return NormalizationResult(normalizedExpression: normalized)
        }

        if looksLikeDirectExpression(trimmed) {
            return NormalizationResult(normalizedExpression: normalizeDirectExpression(trimmed))
        }

        throw CalculationError.unsupportedInput(input)
    }

    private func normalizeAggregate(_ input: String) -> String? {
        guard input.contains("求和") else {
            return nil
        }
        let numbers = extractNumbers(from: input)
        guard numbers.count >= 2 else {
            return nil
        }
        return numbers.joined(separator: " + ")
    }

    private func normalizePower(_ input: String) -> String? {
        let pattern = #"^\s*(-?\d+(?:\.\d+)?)\s*的\s*(-?\d+(?:\.\d+)?)\s*次方\s*$"#
        guard let match = input.firstMatch(of: pattern) else {
            return nil
        }
        return "pow(\(match[0]), \(match[1]))"
    }

    private func normalizeSquare(_ input: String) -> String? {
        let chinesePattern = #"^\s*(-?\d+(?:\.\d+)?)\s*的平方\s*$"#
        if let match = input.firstMatch(of: chinesePattern) {
            return "pow(\(match[0]), 2)"
        }

        let englishPattern = #"^\s*square\s+(-?\d+(?:\.\d+)?)\s*$"#
        if let match = input.firstMatch(of: englishPattern) {
            return "pow(\(match[0]), 2)"
        }

        return nil
    }

    private func normalizeSquareRoot(_ input: String) -> String? {
        let rootPatterns = [
            #"^\s*(-?\d+(?:\.\d+)?)\s*开平方\s*$"#,
            #"^\s*(-?\d+(?:\.\d+)?)\s*的平方根\s*$"#,
        ]

        for pattern in rootPatterns {
            if let match = input.firstMatch(of: pattern) {
                return "sqrt(\(match[0]))"
            }
        }

        return nil
    }

    private func normalizeSequentialArithmetic(_ input: String) -> String? {
        let sanitized = input.replacingOccurrences(of: " ", with: "")
        let explicitPattern = #"^\s*(-?\d+(?:\.\d+)?)(加|减去|减|乘以|乘|除以|除)(-?\d+(?:\.\d+)?)(再)(加|减去|减|乘以|乘|除以|除)(-?\d+(?:\.\d+)?)\s*$"#
        if let match = sanitized.firstMatch(of: explicitPattern) {
            guard
                let firstOperator = SupportedPhraseCatalog.arithmeticKeywords[match[1]],
                let secondOperator = SupportedPhraseCatalog.arithmeticKeywords[match[4]]
            else {
                return nil
            }

            return "(\(match[0]) \(firstOperator) \(match[2])) \(secondOperator) \(match[5])"
        }

        let implicitSubjectPattern = #"^\s*(-?\d+(?:\.\d+)?)(?:先)?(加|减去|减|乘以|乘|除以|除)(-?\d+(?:\.\d+)?)(再)(加|减去|减|乘以|乘|除以|除)(-?\d+(?:\.\d+)?)\s*$"#
        guard let match = sanitized.firstMatch(of: implicitSubjectPattern) else {
            return nil
        }

        guard
            let firstOperator = SupportedPhraseCatalog.arithmeticKeywords[match[1]],
            let secondOperator = SupportedPhraseCatalog.arithmeticKeywords[match[4]]
        else {
            return nil
        }

        return "(\(match[0]) \(firstOperator) \(match[2])) \(secondOperator) \(match[5])"
    }

    private func normalizeBinaryArithmetic(_ input: String) -> String? {
        let sanitized = input.replacingOccurrences(of: " ", with: "")
        let pattern = #"^\s*(-?\d+(?:\.\d+)?)(加上|加|减去|减|乘以|乘|除以|除)(-?\d+(?:\.\d+)?)\s*$"#
        guard let match = sanitized.firstMatch(of: pattern) else {
            return nil
        }
        guard let op = SupportedPhraseCatalog.arithmeticKeywords[match[1]] else {
            return nil
        }
        return "\(match[0]) \(op) \(match[2])"
    }

    private func looksLikeDirectExpression(_ input: String) -> Bool {
        let allowed = CharacterSet(charactersIn: "0123456789.+-*/^(), ")
        if input.range(of: "sqrt(", options: .caseInsensitive) != nil || input.range(of: "pow(", options: .caseInsensitive) != nil {
            return true
        }
        return input.unicodeScalars.allSatisfy { allowed.contains($0) }
    }

    private func normalizeDirectExpression(_ input: String) -> String {
        input
            .replacingOccurrences(of: "，", with: ",")
            .replacingOccurrences(of: "（", with: "(")
            .replacingOccurrences(of: "）", with: ")")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extractNumbers(from input: String) -> [String] {
        let pattern = #"-?\d+(?:\.\d+)?"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(input.startIndex..<input.endIndex, in: input)
        let matches = regex?.matches(in: input, range: range) ?? []
        return matches.compactMap { match in
            guard let range = Range(match.range, in: input) else {
                return nil
            }
            return String(input[range])
        }
    }
}

private extension String {
    func firstMatch(of pattern: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }

        let fullRange = NSRange(startIndex..<endIndex, in: self)
        guard let match = regex.firstMatch(in: self, range: fullRange) else {
            return nil
        }

        var groups: [String] = []
        for index in 1..<match.numberOfRanges {
            guard let range = Range(match.range(at: index), in: self) else {
                return nil
            }
            groups.append(String(self[range]))
        }
        return groups
    }
}
