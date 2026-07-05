import SwiftUI

struct SliderPreviewControl: ControlPreviewDefinition {
    let id = "slider"
    let title = "Slider"
    let category = ControlCategory.controls
    let systemImage = "slider.horizontal.3"
    let keywords = ["range", "value", "continuous", "minimum", "maximum", "step"]

    func makeState() -> SliderPreviewState {
        SliderPreviewState()
    }

    func makePreview(state: Binding<SliderPreviewState>) -> some View {
        Slider(
            value: valueBinding(state),
            in: range(for: state.wrappedValue),
            step: max(state.wrappedValue.step, 0.1)
        )
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .disabled(state.wrappedValue.isDisabled)
        .frame(maxWidth: 360)
    }

    func makeInspector(state: Binding<SliderPreviewState>) -> some View {
        Section("Content") {
            Toggle("Disabled", isOn: state.isDisabled)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }

        Section("Values") {
            Stepper(
                "Value: \(state.wrappedValue.value, specifier: "%.1f")",
                value: state.value,
                in: -100...100,
                step: max(state.wrappedValue.step, 0.1)
            )
            Stepper(
                "Minimum: \(state.wrappedValue.minimum, specifier: "%.0f")",
                value: state.minimum,
                in: -100...99,
                step: 1
            )
            Stepper(
                "Maximum: \(state.wrappedValue.maximum, specifier: "%.0f")",
                value: state.maximum,
                in: -99...100,
                step: 1
            )
            Stepper(
                "Step: \(state.wrappedValue.step, specifier: "%.1f")",
                value: state.step,
                in: 0.1...25,
                step: 0.1
            )
        }
    }

    func makeCode(state: SliderPreviewState) -> String {
        let range = range(for: state)
        var sliderLines = [
            "Slider(",
            "    value: $value,",
            "    in: \(SwiftUICode.doubleLiteral(range.lowerBound))...\(SwiftUICode.doubleLiteral(range.upperBound)),",
            "    step: \(SwiftUICode.doubleLiteral(max(state.step, 0.1)))",
            ")"
        ]

        sliderLines.append(".tint(.\(state.tint.codeName))")
        sliderLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            sliderLines.append(".disabled(true)")
        }

        sliderLines.append(".frame(maxWidth: 360)")

        return SwiftUICode.view(
            named: "SliderExample",
            declarations: ["@State private var value = \(SwiftUICode.doubleLiteral(state.value, forceFraction: true))"],
            body: sliderLines.joined(separator: "\n")
        )
    }

    private func range(for state: SliderPreviewState) -> ClosedRange<Double> {
        min(state.minimum, state.maximum - 0.1)...max(state.maximum, state.minimum + 0.1)
    }

    private func valueBinding(_ state: Binding<SliderPreviewState>) -> Binding<Double> {
        Binding<Double>(
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

struct SliderPreviewState {
    var value = 50.0
    var minimum = 0.0
    var maximum = 100.0
    var step = 5.0
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}
