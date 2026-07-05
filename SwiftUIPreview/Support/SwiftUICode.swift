import Foundation

enum SwiftUICode {
    static func view(named name: String, declarations: [String] = [], body: String) -> String {
        var lines = [
            "import SwiftUI",
            "",
            "struct \(name): View {"
        ]

        if !declarations.isEmpty {
            for (index, declaration) in declarations.enumerated() {
                if index > 0 {
                    lines.append("")
                }

                lines.append(contentsOf: indent(declaration, level: 1).components(separatedBy: "\n"))
            }

            lines.append("")
        }

        lines.append("    var body: some View {")
        lines.append(contentsOf: indent(body, level: 2).components(separatedBy: "\n"))
        lines.append("    }")
        lines.append("}")

        return lines.joined(separator: "\n")
    }

    static func stringLiteral(_ value: String) -> String {
        "\"\(escapedStringContent(value))\""
    }

    static func escapedStringContent(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
    }

    static func doubleLiteral(_ value: Double, forceFraction: Bool = false) -> String {
        if value.rounded() == value {
            let integer = String(Int(value))
            return forceFraction ? "\(integer).0" : integer
        }

        return String(format: "%.10g", value)
    }

    static func indented(_ code: String, level: Int = 1) -> String {
        indent(code, level: level)
    }

    static func lineNumberText(for code: String) -> String {
        let lineCount = max(1, code.components(separatedBy: "\n").count)
        return (1...lineCount)
            .map(String.init)
            .joined(separator: "\n")
    }

    private static func indent(_ code: String, level: Int) -> String {
        let prefix = String(repeating: "    ", count: level)

        return code.components(separatedBy: "\n")
            .map { line in
                line.isEmpty ? line : prefix + line
            }
            .joined(separator: "\n")
    }
}
