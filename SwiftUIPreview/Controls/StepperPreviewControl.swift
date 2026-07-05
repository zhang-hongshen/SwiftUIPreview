import SwiftUI

struct StepperPreviewControl: ControlPreviewDefinition {
    let id = "stepper"
    let title = "Stepper"
    let category = ControlCategory.controls
    let systemImage = "plusminus"
    let keywords = ["increment", "decrement", "number", "value", "step"]

    func makeState() -> StepperPreviewState {
        StepperPreviewState()
    }

    func makePreview(state: Binding<StepperPreviewState>) -> some View {
        Stepper(
            value: valueBinding(state),
            in: range(for: state.wrappedValue),
            step: max(state.wrappedValue.step, 1)
        ) {
            Text(state.wrappedValue.label)
                .frame(minWidth: 120, alignment: .leading)
        }
        .controlSize(state.wrappedValue.controlSize.controlSize)
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .disabled(state.wrappedValue.isDisabled)
    }

    func makeInspector(state: Binding<StepperPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Toggle("Disabled", isOn: state.isDisabled)
        }

        Section("Values") {
            Stepper("Value: \(state.wrappedValue.value)", value: state.value, in: -100...100)
            Stepper("Minimum: \(state.wrappedValue.minimum)", value: state.minimum, in: -100...99)
            Stepper("Maximum: \(state.wrappedValue.maximum)", value: state.maximum, in: -99...100)
            Stepper("Step: \(state.wrappedValue.step)", value: state.step, in: 1...20)
        }

        Section("Style") {
            OptionPicker(title: "Control Size", selection: state.controlSize)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: StepperPreviewState) -> String {
        let range = range(for: state)
        var initializer = "Stepper(value: $quantity, in: \(range.lowerBound)...\(range.upperBound)"

        if state.step != 1 {
            initializer += ", step: \(max(state.step, 1))"
        }

        initializer += ")"

        var stepperLines = [
            "\(initializer) {",
            "    Text(\(SwiftUICode.stringLiteral(state.label)))",
            "        .frame(minWidth: 120, alignment: .leading)",
            "}"
        ]

        if state.controlSize != .regular {
            stepperLines.append(".controlSize(.\(state.controlSize.rawValue))")
        }

        stepperLines.append(".tint(.\(state.tint.codeName))")
        stepperLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            stepperLines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "StepperExample",
            declarations: ["@State private var quantity = \(state.value)"],
            body: stepperLines.joined(separator: "\n")
        )
    }

    private func range(for state: StepperPreviewState) -> ClosedRange<Int> {
        min(state.minimum, state.maximum - 1)...max(state.maximum, state.minimum + 1)
    }

    private func valueBinding(_ state: Binding<StepperPreviewState>) -> Binding<Int> {
        Binding<Int>(
            get: {
                let range = range(for: state.wrappedValue)
                return min(max(state.wrappedValue.value, range.lowerBound), range.upperBound)
            },
            set: { newValue in
                var nextState = state.wrappedValue
                nextState.value = newValue
                state.wrappedValue = nextState
            }
        )
    }
}

struct StepperPreviewState {
    var label = "Quantity"
    var value = 4
    var minimum = 0
    var maximum = 20
    var step = 1
    var controlSize = PreviewControlSizeOption.regular
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}
