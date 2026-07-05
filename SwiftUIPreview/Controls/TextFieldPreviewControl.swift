import SwiftUI

struct TextFieldPreviewControl: ControlPreviewDefinition {
    let id = "text-field"
    let title = "TextField"
    let category = ControlCategory.controls
    let systemImage = "text.cursor"
    let keywords = ["text", "input", "prompt", "secure", "rounded", "plain"]

    func makeState() -> TextFieldPreviewState {
        TextFieldPreviewState()
    }

    func makePreview(state: Binding<TextFieldPreviewState>) -> some View {
        styledTextField(state: state)
            .frame(width: 320)
            .disabled(state.wrappedValue.isDisabled)
    }

    func makeInspector(state: Binding<TextFieldPreviewState>) -> some View {
        Section("Content") {
            TextField("Text", text: state.text)
            TextField("Prompt", text: state.prompt)
            Toggle("Secure Entry", isOn: state.isSecure)
            Toggle("Multiline", isOn: state.isMultiline)
                .disabled(state.wrappedValue.isSecure)
        }

        Section("Style") {
            OptionPicker(title: "Text Field Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: TextFieldPreviewState) -> String {
        var fieldLines: [String]

        if state.isSecure {
            fieldLines = [
                "SecureField(\(SwiftUICode.stringLiteral(state.prompt)), text: $text)"
            ]
        } else if state.isMultiline {
            fieldLines = [
                "TextField(\(SwiftUICode.stringLiteral(state.prompt)), text: $text, axis: .vertical)",
                ".lineLimit(3...5)"
            ]
        } else {
            fieldLines = [
                "TextField(\(SwiftUICode.stringLiteral(state.prompt)), text: $text)"
            ]
        }

        if state.style != .automatic {
            fieldLines.append(".textFieldStyle(.\(state.style.codeName))")
        }

        fieldLines.append(".tint(.\(state.tint.codeName))")
        fieldLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        fieldLines.append(".frame(width: 320)")

        if state.isDisabled {
            fieldLines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "TextFieldExample",
            declarations: ["@State private var text = \(SwiftUICode.stringLiteral(state.text))"],
            body: fieldLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledTextField(state: Binding<TextFieldPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        switch snapshot.style {
        case .automatic:
            textField(state: state)
                .textFieldStyle(.automatic)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
        case .roundedBorder:
            textField(state: state)
                .textFieldStyle(.roundedBorder)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
        case .plain:
            textField(state: state)
                .textFieldStyle(.plain)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
        }
    }

    @ViewBuilder
    private func textField(state: Binding<TextFieldPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        if snapshot.isSecure {
            SecureField(snapshot.prompt, text: state.text)
        } else if snapshot.isMultiline {
            TextField(snapshot.prompt, text: state.text, axis: .vertical)
                .lineLimit(3...5)
        } else {
            TextField(snapshot.prompt, text: state.text)
        }
    }
}

struct TextFieldPreviewState {
    var text = "SwiftUIPreview"
    var prompt = "Project name"
    var style = TextFieldStyleOption.roundedBorder
    var isSecure = false
    var isMultiline = false
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}

enum TextFieldStyleOption: String, PreviewOption {
    case automatic
    case roundedBorder
    case plain

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .roundedBorder:
            "Rounded Border"
        case .plain:
            "Plain"
        }
    }
}

extension TextFieldStyleOption {
    var codeName: String {
        switch self {
        case .automatic:
            "automatic"
        case .roundedBorder:
            "roundedBorder"
        case .plain:
            "plain"
        }
    }
}
