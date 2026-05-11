import Foundation

struct Parser {
    private var tokens: [Token]
    private var position: Int = 0

    init(tokens: [Token]) {
        self.tokens = tokens
    }

    mutating func parse() throws -> Expression {
        let expression = try parseExpression()
        if currentToken != nil {
            throw CalculationError.invalidSyntax("Unexpected trailing tokens")
        }
        return expression
    }

    private var currentToken: Token? {
        guard position < tokens.count else {
            return nil
        }
        return tokens[position]
    }

    private mutating func advance() {
        position += 1
    }

    private mutating func parseExpression() throws -> Expression {
        try parseAddition()
    }

    private mutating func parseAddition() throws -> Expression {
        var expression = try parseMultiplication()

        while let token = currentToken {
            switch token {
            case .plus:
                advance()
                let rhs = try parseMultiplication()
                expression = .binary(.add, expression, rhs)
            case .minus:
                advance()
                let rhs = try parseMultiplication()
                expression = .binary(.subtract, expression, rhs)
            default:
                return expression
            }
        }

        return expression
    }

    private mutating func parseMultiplication() throws -> Expression {
        var expression = try parsePower()

        while let token = currentToken {
            switch token {
            case .star:
                advance()
                let rhs = try parsePower()
                expression = .binary(.multiply, expression, rhs)
            case .slash:
                advance()
                let rhs = try parsePower()
                expression = .binary(.divide, expression, rhs)
            default:
                return expression
            }
        }

        return expression
    }

    private mutating func parsePower() throws -> Expression {
        var expression = try parseUnary()

        if case .caret? = currentToken {
            advance()
            let rhs = try parsePower()
            expression = .binary(.power, expression, rhs)
        }

        return expression
    }

    private mutating func parseUnary() throws -> Expression {
        if case .minus? = currentToken {
            advance()
            return .unaryMinus(try parseUnary())
        }
        return try parsePrimary()
    }

    private mutating func parsePrimary() throws -> Expression {
        guard let token = currentToken else {
            throw CalculationError.invalidSyntax("Unexpected end of input")
        }

        switch token {
        case .number(let value):
            advance()
            return .number(value)
        case .identifier(let identifier):
            return try parseFunction(identifier: identifier)
        case .leftParen:
            advance()
            let expression = try parseExpression()
            guard case .rightParen? = currentToken else {
                throw CalculationError.invalidSyntax("Missing closing parenthesis")
            }
            advance()
            return expression
        default:
            throw CalculationError.invalidSyntax("Unexpected token")
        }
    }

    private mutating func parseFunction(identifier: String) throws -> Expression {
        advance()
        guard case .leftParen? = currentToken else {
            throw CalculationError.invalidSyntax("Expected opening parenthesis after \(identifier)")
        }
        advance()

        var arguments: [Expression] = []
        if case .rightParen? = currentToken {
            advance()
        } else {
            while true {
                arguments.append(try parseExpression())
                if case .comma? = currentToken {
                    advance()
                    continue
                }
                guard case .rightParen? = currentToken else {
                    throw CalculationError.invalidSyntax("Missing closing parenthesis in function call")
                }
                advance()
                break
            }
        }

        guard let function = BuiltinFunction(rawValue: identifier) else {
            throw CalculationError.unsupportedInput(identifier)
        }
        return .function(function, arguments)
    }
}
