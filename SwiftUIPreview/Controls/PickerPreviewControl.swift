import SwiftUI

struct PickerPreviewControl: ControlPreviewDefinition {
    let id = "picker"
    let title = "Picker"
    let category = ControlCategory.controls
    let systemImage = "list.bullet"
    let keywords = ["choose", "selection", "menu", "segmented", "radio", "inline"]

    func makeState() -> PickerPreviewState {
        PickerPreviewState()
    }

    func makePreview(state: Binding<PickerPreviewState>) -> some View {
        styledPicker(state: state)
            .frame(maxWidth: 360)
    }

    func makeInspector(state: Binding<PickerPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Stepper(
                "Options: \(state.wrappedValue.optionCount)",
                value: optionCountBinding(state),
                in: 2...6
            )
        }

        Section("Style") {
            OptionPicker(title: "Picker Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: PickerPreviewState) -> String {
        var pickerLines = [
            "Picker(\(SwiftUICode.stringLiteral(state.label)), selection: $selection) {",
            "    ForEach(0..<\(state.optionCount), id: \\.self) { index in",
            "        Text(\"Option \\(index + 1)\").tag(index)",
            "    }",
            "}"
        ]

        if state.style != .automatic {
            pickerLines.append(".pickerStyle(.\(state.style.codeName))")
        }

        pickerLines.append(".tint(.\(state.tint.codeName))")
        pickerLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            pickerLines.append(".disabled(true)")
        }

        pickerLines.append(".frame(maxWidth: 360)")

        return SwiftUICode.view(
            named: "PickerExample",
            declarations: ["@State private var selection = \(min(state.selectedIndex, state.optionCount - 1))"],
            body: pickerLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledPicker(state: Binding<PickerPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        switch snapshot.style {
        case .automatic:
            picker(state: state)
                .pickerStyle(.automatic)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .menu:
            picker(state: state)
                .pickerStyle(.menu)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .segmented:
            picker(state: state)
                .pickerStyle(.segmented)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .radioGroup:
            picker(state: state)
                .pickerStyle(.radioGroup)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        case .inline:
            picker(state: state)
                .pickerStyle(.inline)
                .tint(snapshot.tint.color)
                .previewSystemFont(size: snapshot.fontSize, width: snapshot.fontWidth)
                .disabled(snapshot.isDisabled)
        }
    }

    private func picker(state: Binding<PickerPreviewState>) -> some View {
        Picker(state.wrappedValue.label, selection: state.selectedIndex) {
            ForEach(0..<state.wrappedValue.optionCount, id: \.self) { index in
                Text("Option \(index + 1)").tag(index)
            }
        }
    }

    private func optionCountBinding(_ state: Binding<PickerPreviewState>) -> Binding<Int> {
        Binding<Int>(
            get: { state.wrappedValue.optionCount },
            set: { newValue in
                var nextState = state.wrappedValue
                nextState.optionCount = newValue
                nextState.selectedIndex = min(nextState.selectedIndex, newValue - 1)
                state.wrappedValue = nextState
            }
        )
    }
}

struct PickerPreviewState {
    var label = "Mode"
    var selectedIndex = 1
    var optionCount = 3
    var style = PickerStyleOption.segmented
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}

enum PickerStyleOption: String, PreviewOption {
    case automatic
    case menu
    case segmented
    case radioGroup
    case inline

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .menu:
            "Menu"
        case .segmented:
            "Segmented"
        case .radioGroup:
            "Radio Group"
        case .inline:
            "Inline"
        }
    }
}

private extension PickerStyleOption {
    var codeName: String {
        switch self {
        case .automatic:
            "automatic"
        case .menu:
            "menu"
        case .segmented:
            "segmented"
        case .radioGroup:
            "radioGroup"
        case .inline:
            "inline"
        }
    }
}
