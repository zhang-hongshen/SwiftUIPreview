import SwiftUI

struct TogglePreviewControl: ControlPreviewDefinition {
    let id = "toggle"
    let title = "Toggle"
    let category = ControlCategory.controls
    let systemImage = "switch.2"
    let keywords = ["boolean", "checkbox", "switch", "on", "off"]

    func makeState() -> TogglePreviewState {
        TogglePreviewState()
    }

    func makePreview(state: Binding<TogglePreviewState>) -> some View {
        styledToggle(state: state)
    }

    func makeInspector(state: Binding<TogglePreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Toggle("Value", isOn: state.isOn)
        }

        Section("Style") {
            OptionPicker(title: "Toggle Style", selection: state.style)
            OptionPicker(title: "Control Size", selection: state.controlSize)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: TogglePreviewState) -> String {
        var toggleLines = [
            "Toggle(\(SwiftUICode.stringLiteral(state.label)), isOn: $isEnabled)"
        ]

        if state.style != .automatic {
            toggleLines.append(".toggleStyle(.\(state.style.codeName))")
        }

        if state.controlSize != .regular {
            toggleLines.append(".controlSize(.\(state.controlSize.rawValue))")
        }

        toggleLines.append(".tint(.\(state.tint.codeName))")
        toggleLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            toggleLines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "ToggleExample",
            declarations: ["@State private var isEnabled = \(state.isOn)"],
            body: toggleLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledToggle(state: Binding<TogglePreviewState>) -> some View {
        let snapshot = state.wrappedValue

        switch snapshot.style {
        case .automatic:
            baseToggle(state: state)
                .toggleStyle(.automatic)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .switch:
            baseToggle(state: state)
                .toggleStyle(.switch)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .checkbox:
            baseToggle(state: state)
                .toggleStyle(.checkbox)
                .controlSize(snapshot.controlSize.controlSize)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        }
    }

    private func baseToggle(state: Binding<TogglePreviewState>) -> some View {
        Toggle(state.wrappedValue.label, isOn: state.isOn)
    }
}

struct TogglePreviewState {
    var label = "Enable Sync"
    var isOn = true
    var style = ToggleStyleOption.switch
    var controlSize = PreviewControlSizeOption.regular
    var tint = PreviewColorOption.green
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}

enum ToggleStyleOption: String, PreviewOption {
    case automatic
    case `switch`
    case checkbox

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .switch:
            "Switch"
        case .checkbox:
            "Checkbox"
        }
    }
}

private extension ToggleStyleOption {
    var codeName: String {
        switch self {
        case .automatic:
            "automatic"
        case .switch:
            "switch"
        case .checkbox:
            "checkbox"
        }
    }
}
