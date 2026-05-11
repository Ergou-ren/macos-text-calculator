import Foundation

enum Token: Equatable {
    case number(Decimal)
    case identifier(String)
    case plus
    case minus
    case star
    case slash
    case caret
    case comma
    case leftParen
    case rightParen
}

struct Tokenizer {
    func tokenize(_ input: String) throws -> [Token] {
        var tokens: [Token] = []
        var index = input.startIndex

        while index < input.endIndex {
            let character = input[index]

            if character.isWhitespace {
                index = input.index(after: index)
                continue
            }

            switch character {
            case "+":
                tokens.append(.plus)
                index = input.index(after: index)
            case "-":
                tokens.append(.minus)
                index = input.index(after: index)
            case "*":
                tokens.append(.star)
                index = input.index(after: index)
            case "/":
                tokens.append(.slash)
                index = input.index(after: index)
            case "^":
                tokens.append(.caret)
                index = input.index(after: index)
            case ",":
                tokens.append(.comma)
                index = input.index(after: index)
            case "(":
                tokens.append(.leftParen)
                index = input.index(after: index)
            case ")":
                tokens.append(.rightParen)
                index = input.index(after: index)
            default:
                if character.isNumber || character == "." {
                    let (number, nextIndex) = consumeNumber(from: input, at: index)
                    tokens.append(.number(number))
                    index = nextIndex
                } else if character.isLetter {
                    let (identifier, nextIndex) = consumeIdentifier(from: input, at: index)
                    tokens.append(.identifier(identifier.lowercased()))
                    index = nextIndex
                } else {
                    throw CalculationError.invalidSyntax("Unexpected character: \(character)")
                }
            }
        }

        return tokens
    }

    private func consumeNumber(from input: String, at start: String.Index) -> (Decimal, String.Index) {
        var index = start
        var literal = ""

        while index < input.endIndex {
            let character = input[index]
            if character.isNumber || character == "." {
                literal.append(character)
                index = input.index(after: index)
            } else {
                break
            }
        }

        return (Decimal(string: literal, locale: Locale(identifier: "en_US_POSIX")) ?? 0, index)
    }

    private func consumeIdentifier(from input: String, at start: String.Index) -> (String, String.Index) {
        var index = start
        var identifier = ""

        while index < input.endIndex {
            let character = input[index]
            if character.isLetter {
                identifier.append(character)
                index = input.index(after: index)
            } else {
                break
            }
        }

        return (identifier, index)
    }
}
