import Foundation

public struct SupportedPhraseCatalog {
    public static let supportedFamilies: [String] = [
        "sum / aggregate",
        "sequential arithmetic",
        "binary arithmetic",
        "exponent / square",
        "square root",
    ]

    public static let unsupportedExamples: [String] = [
        "把 3 公里换算成米",
        "解 2x + 3 = 11",
        "把 3 公里换算成米再加税后打九折",
    ]

    static let arithmeticKeywords: [String: String] = [
        "加": "+",
        "加上": "+",
        "减": "-",
        "减去": "-",
        "乘": "*",
        "乘以": "*",
        "除": "/",
        "除以": "/",
    ]
}
