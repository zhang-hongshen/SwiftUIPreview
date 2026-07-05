import SwiftUI

enum SwiftCodeHighlighter {
    private static let keywords: Set<String> = [
        "as", "associatedtype", "break", "case", "catch", "class", "continue", "default",
        "defer", "do", "else", "enum", "extension", "false", "for", "func", "guard",
        "if", "import", "in", "init", "let", "nil", "private", "protocol", "return",
        "self", "some", "static", "struct", "switch", "true", "typealias", "var",
        "where", "while"
    ]

    static func highlighted(_ code: String) -> AttributedString {
        var output = AttributedString("")
        var index = code.startIndex

        while index < code.endIndex {
            if code[index...].hasPrefix("//") {
                let end = code[index...].firstIndex(of: "\n") ?? code.endIndex
                append(String(code[index..<end]), color: .secondary, to: &output)
                index = end
                continue
            }

            let character = code[index]

            if character == "\"" {
                let end = stringLiteralEnd(in: code, from: index)
                append(String(code[index..<end]), color: .red, to: &output)
                index = end
                continue
            }

            if character == "@" {
                let end = tokenEnd(in: code, from: code.index(after: index))
                append(String(code[index..<end]), color: .blue, to: &output)
                index = end
                continue
            }

            if isNumber(character) {
                let end = numberEnd(in: code, from: index)
                append(String(code[index..<end]), color: .orange, to: &output)
                index = end
                continue
            }

            if isIdentifierStart(character) {
                let end = tokenEnd(in: code, from: index)
                let token = String(code[index..<end])
                append(token, color: color(for: token), to: &output)
                index = end
                continue
            }

            append(String(character), to: &output)
            index = code.index(after: index)
        }

        return output
    }

    private static func append(_ text: String, color: Color? = nil, to output: inout AttributedString) {
        var segment = AttributedString(text)

        if let color {
            segment.foregroundColor = color
        }

        output += segment
    }

    private static func color(for token: String) -> Color? {
        if keywords.contains(token) {
            return .purple
        }

        if token.first?.isUppercase == true {
            return .teal
        }

        return nil
    }

    private static func stringLiteralEnd(in code: String, from start: String.Index) -> String.Index {
        var index = code.index(after: start)
        var isEscaped = false

        while index < code.endIndex {
            let character = code[index]

            if character == "\"" && !isEscaped {
                return code.index(after: index)
            }

            isEscaped = character == "\\" && !isEscaped
            if character != "\\" {
                isEscaped = false
            }

            index = code.index(after: index)
        }

        return code.endIndex
    }

    private static func tokenEnd(in code: String, from start: String.Index) -> String.Index {
        var index = start

        while index < code.endIndex, isIdentifierBody(code[index]) {
            index = code.index(after: index)
        }

        return index
    }

    private static func numberEnd(in code: String, from start: String.Index) -> String.Index {
        var index = start

        while index < code.endIndex {
            let character = code[index]

            guard isNumber(character) || character == "." else {
                break
            }

            index = code.index(after: index)
        }

        return index
    }

    private static func isIdentifierStart(_ character: Character) -> Bool {
        character == "_" || containsOnly(character, in: .letters)
    }

    private static func isIdentifierBody(_ character: Character) -> Bool {
        isIdentifierStart(character) || isNumber(character)
    }

    private static func isNumber(_ character: Character) -> Bool {
        containsOnly(character, in: .decimalDigits)
    }

    private static func containsOnly(_ character: Character, in characterSet: CharacterSet) -> Bool {
        character.unicodeScalars.allSatisfy { characterSet.contains($0) }
    }
}
