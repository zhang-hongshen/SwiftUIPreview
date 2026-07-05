import SwiftUI

struct ButtonPreviewControl: ControlPreviewDefinition {
    let id = "button"
    let title = "Button"
    let category = ControlCategory.controls
    let systemImage = "cursorarrow.click"
    let keywords = ["action", "tap", "bordered", "plain", "prominent", "link", "role"]

    func makeState() -> ButtonPreviewState {
        ButtonPreviewState()
    }

    func makePreview(state: Binding<ButtonPreviewState>) -> some View {
        styledButton(state: state)
    }

    func makeInspector(state: Binding<ButtonPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Toggle("Show Icon", isOn: state.showsIcon)
        }

        Section("Style") {
            OptionPicker(title: "Button Style", selection: state.style)
            OptionPicker(title: "Role", selection: state.role)
            OptionPicker(title: "Control Size", selection: state.controlSize)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: ButtonPreviewState) -> String {
        var buttonLines: [String]

        if state.showsIcon {
            buttonLines = [
                "\(buttonInitializer(state)) {",
                "} label: {",
                "    Label(\(SwiftUICode.stringLiteral(state.label)), systemImage: \"sparkles\")",
                "}"
            ]
        } else {
            buttonLines = [
                "\(buttonInitializer(state, title: SwiftUICode.stringLiteral(state.label))) {",
                "}"
            ]
        }

        if state.style != .automatic {
            buttonLines.append(".buttonStyle(.\(state.style.codeName))")
        }

        if state.controlSize != .regular {
            buttonLines.append(".controlSize(.\(state.controlSize.rawValue))")
        }

        buttonLines.append(".tint(.\(state.tint.codeName))")
        buttonLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            buttonLines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "ButtonExample",
            body: buttonLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledButton(state: Binding<ButtonPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        switch snapshot.style {
        case .automatic:
            baseButton(state: state)
                .buttonStyle(.automatic)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .bordered:
            baseButton(state: state)
                .buttonStyle(.bordered)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .borderedProminent:
            baseButton(state: state)
                .buttonStyle(.borderedProminent)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .plain:
            baseButton(state: state)
                .buttonStyle(.plain)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .link:
            baseButton(state: state)
                .buttonStyle(.link)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        }
    }

    private func baseButton(state: Binding<ButtonPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        return Button(role: snapshot.role.buttonRole) {
        } label: {
            if snapshot.showsIcon {
                Label(snapshot.label, systemImage: "sparkles")
            } else {
                Text(snapshot.label)
            }
        }
    }

    private func buttonInitializer(_ state: ButtonPreviewState, title: String? = nil) -> String {
        switch (title, state.role) {
        case let (.some(title), .none):
            "Button(\(title))"
        case let (.some(title), role):
            "Button(\(title), role: .\(role.rawValue))"
        case (.none, .none):
            "Button"
        case (.none, let role):
            "Button(role: .\(role.rawValue))"
        }
    }
}

struct ButtonPreviewState {
    var label = "Save"
    var showsIcon = true
    var style = ButtonStyleOption.borderedProminent
    var role = ButtonRoleOption.none
    var controlSize = PreviewControlSizeOption.regular
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}

enum ButtonStyleOption: String, PreviewOption {
    case automatic
    case bordered
    case borderedProminent
    case plain
    case link

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .bordered:
            "Bordered"
        case .borderedProminent:
            "Bordered Prominent"
        case .plain:
            "Plain"
        case .link:
            "Link"
        }
    }
}

private extension ButtonStyleOption {
    var codeName: String {
        switch self {
        case .automatic:
            "automatic"
        case .bordered:
            "bordered"
        case .borderedProminent:
            "borderedProminent"
        case .plain:
            "plain"
        case .link:
            "link"
        }
    }
}

enum ButtonRoleOption: String, PreviewOption {
    case none
    case cancel
    case destructive

    var title: String {
        switch self {
        case .none:
            "None"
        case .cancel:
            "Cancel"
        case .destructive:
            "Destructive"
        }
    }

    var buttonRole: ButtonRole? {
        switch self {
        case .none:
            nil
        case .cancel:
            .cancel
        case .destructive:
            .destructive
        }
    }
}
