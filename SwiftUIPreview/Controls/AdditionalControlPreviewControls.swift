import SwiftUI
#if os(macOS)
import AppKit
#endif

struct SecureFieldPreviewControl: ControlPreviewDefinition {
    let id = "secure-field"
    let title = "SecureField"
    let category = ControlCategory.controls
    let systemImage = "lock"
    let keywords = ["password", "secure", "text", "input"]

    func makeState() -> SecureFieldPreviewState {
        SecureFieldPreviewState()
    }

    func makePreview(state: Binding<SecureFieldPreviewState>) -> some View {
        secureField(state: state)
            .frame(width: 320)
            .tint(state.wrappedValue.tint.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .disabled(state.wrappedValue.isDisabled)
    }

    func makeInspector(state: Binding<SecureFieldPreviewState>) -> some View {
        Section("Content") {
            TextField("Text", text: state.text)
            TextField("Prompt", text: state.prompt)
        }

        Section("Style") {
            OptionPicker(title: "Text Field Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: SecureFieldPreviewState) -> String {
        var lines = [
            "SecureField(\(SwiftUICode.stringLiteral(state.prompt)), text: $password)"
        ]

        if state.style != .roundedBorder {
            lines.append(".textFieldStyle(.\(state.style.codeName))")
        } else {
            lines.append(".textFieldStyle(.roundedBorder)")
        }

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(".frame(width: 320)")

        if state.isDisabled {
            lines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "SecureFieldExample",
            declarations: ["@State private var password = \(SwiftUICode.stringLiteral(state.text))"],
            body: lines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func secureField(state: Binding<SecureFieldPreviewState>) -> some View {
        switch state.wrappedValue.style {
        case .automatic:
            SecureField(state.wrappedValue.prompt, text: state.text)
                .textFieldStyle(.automatic)
        case .roundedBorder:
            SecureField(state.wrappedValue.prompt, text: state.text)
                .textFieldStyle(.roundedBorder)
        case .plain:
            SecureField(state.wrappedValue.prompt, text: state.text)
                .textFieldStyle(.plain)
        }
    }
}

struct SecureFieldPreviewState {
    var text = "secret"
    var prompt = "Password"
    var style = TextFieldStyleOption.roundedBorder
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}

struct TextEditorPreviewControl: ControlPreviewDefinition {
    let id = "text-editor"
    let title = "TextEditor"
    let category = ControlCategory.controls
    let systemImage = "doc.text"
    let keywords = ["multiline", "text", "editor", "input"]

    func makeState() -> TextEditorPreviewState {
        TextEditorPreviewState()
    }

    func makePreview(state: Binding<TextEditorPreviewState>) -> some View {
        TextEditor(text: state.text)
            .font(.system(state.wrappedValue.fontSize.textStyle, design: state.wrappedValue.usesMonospacedFont ? .monospaced : .default))
            .fontWidth(state.wrappedValue.fontWidth.width)
            .tint(state.wrappedValue.tint.color)
            .frame(width: 360, height: state.wrappedValue.height)
            .disabled(state.wrappedValue.isDisabled)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.quaternary)
            }
    }

    func makeInspector(state: Binding<TextEditorPreviewState>) -> some View {
        Section("Content") {
            TextEditor(text: state.text)
                .frame(height: 90)
        }

        Section("Style") {
            Toggle("Monospaced Font", isOn: state.usesMonospacedFont)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            OptionPicker(title: "Tint", selection: state.tint)
            Slider(value: state.height, in: 100...260, step: 10) {
                Text("Height")
            }
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: TextEditorPreviewState) -> String {
        var lines = ["TextEditor(text: $notes)"]

        if state.usesMonospacedFont {
            lines.append(".font(.system(\(state.fontSize.code), design: .monospaced))")
        } else {
            lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        }

        if state.usesMonospacedFont && state.fontWidth != .standard {
            lines.append(".fontWidth(\(state.fontWidth.code))")
        }

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(".frame(width: 360, height: \(SwiftUICode.doubleLiteral(state.height)))")

        if state.isDisabled {
            lines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "TextEditorExample",
            declarations: ["@State private var notes = \(SwiftUICode.stringLiteral(state.text))"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct TextEditorPreviewState {
    var text = "Write notes here."
    var height = 150.0
    var usesMonospacedFont = false
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var tint = PreviewColorOption.blue
    var isDisabled = false
}

struct DatePickerPreviewControl: ControlPreviewDefinition {
    let id = "date-picker"
    let title = "DatePicker"
    let category = ControlCategory.controls
    let systemImage = "calendar"
    let keywords = ["date", "time", "calendar", "selection"]

    func makeState() -> DatePickerPreviewState {
        DatePickerPreviewState()
    }

    func makePreview(state: Binding<DatePickerPreviewState>) -> some View {
        styledDatePicker(state: state)
            .tint(state.wrappedValue.tint.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: state.wrappedValue.isGraphical ? 340 : 280)
    }

    func makeInspector(state: Binding<DatePickerPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            DatePicker("Date", selection: state.date)
        }

        Section("Style") {
            OptionPicker(title: "Displayed Components", selection: state.components)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Graphical Style", isOn: state.isGraphical)
        }
    }

    func makeCode(state: DatePickerPreviewState) -> String {
        var lines = [
            "DatePicker(\(SwiftUICode.stringLiteral(state.label)), selection: $date, displayedComponents: \(state.components.codeValue))"
        ]

        if state.isGraphical {
            lines.append(".datePickerStyle(.graphical)")
        }

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return SwiftUICode.view(
            named: "DatePickerExample",
            declarations: ["@State private var date = Date(timeIntervalSince1970: \(SwiftUICode.doubleLiteral(state.date.timeIntervalSince1970)))"],
            body: lines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledDatePicker(state: Binding<DatePickerPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        if snapshot.isGraphical {
            DatePicker(
                snapshot.label,
                selection: state.date,
                displayedComponents: snapshot.components.displayedComponents
            )
            .datePickerStyle(.graphical)
        } else {
            DatePicker(
                snapshot.label,
                selection: state.date,
                displayedComponents: snapshot.components.displayedComponents
            )
            .datePickerStyle(.compact)
        }
    }
}

struct DatePickerPreviewState {
    var label = "Due Date"
    var date = Date(timeIntervalSince1970: 1_798_848_000)
    var components = DatePickerComponentsOption.dateAndHour
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isGraphical = false
}

enum DatePickerComponentsOption: String, PreviewOption {
    case date
    case hourAndMinute
    case dateAndHour

    var title: String {
        switch self {
        case .date:
            "Date"
        case .hourAndMinute:
            "Hour and Minute"
        case .dateAndHour:
            "Date and Time"
        }
    }

    var displayedComponents: DatePickerComponents {
        switch self {
        case .date:
            .date
        case .hourAndMinute:
            .hourAndMinute
        case .dateAndHour:
            [.date, .hourAndMinute]
        }
    }

    var codeValue: String {
        switch self {
        case .date:
            ".date"
        case .hourAndMinute:
            ".hourAndMinute"
        case .dateAndHour:
            "[.date, .hourAndMinute]"
        }
    }
}

struct ColorPickerPreviewControl: ControlPreviewDefinition {
    let id = "color-picker"
    let title = "ColorPicker"
    let category = ControlCategory.controls
    let systemImage = "paintpalette"
    let keywords = ["color", "tint", "palette", "selection"]

    func makeState() -> ColorPickerPreviewState {
        ColorPickerPreviewState()
    }

    func makePreview(state: Binding<ColorPickerPreviewState>) -> some View {
        ColorPicker(state.wrappedValue.label, selection: state.color)
            .frame(width: 280)
    }

    func makeInspector(state: Binding<ColorPickerPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            ColorPicker("Color", selection: state.color)
        }
    }

    func makeCode(state: ColorPickerPreviewState) -> String {
        SwiftUICode.view(
            named: "ColorPickerExample",
            declarations: ["@State private var color = \(colorCode(state.color))"],
            body: "ColorPicker(\(SwiftUICode.stringLiteral(state.label)), selection: $color)"
        )
    }

    private func colorCode(_ color: Color) -> String {
        #if os(macOS)
        guard let sRGBColor = NSColor(color).usingColorSpace(.sRGB) else {
            return "Color.blue"
        }

        return "Color(red: \(SwiftUICode.doubleLiteral(Double(sRGBColor.redComponent))), green: \(SwiftUICode.doubleLiteral(Double(sRGBColor.greenComponent))), blue: \(SwiftUICode.doubleLiteral(Double(sRGBColor.blueComponent))))"
        #else
        return "Color.blue"
        #endif
    }
}

struct ColorPickerPreviewState {
    var label = "Accent Color"
    var color = Color.blue
}

struct ProgressViewPreviewControl: ControlPreviewDefinition {
    let id = "progress-view"
    let title = "ProgressView"
    let category = ControlCategory.controls
    let systemImage = "hourglass"
    let keywords = ["progress", "loading", "activity", "indicator"]

    func makeState() -> ProgressViewPreviewState {
        ProgressViewPreviewState()
    }

    func makePreview(state: Binding<ProgressViewPreviewState>) -> some View {
        styledProgressView(state.wrappedValue)
            .tint(state.wrappedValue.tint.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 260)
    }

    func makeInspector(state: Binding<ProgressViewPreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Toggle("Determinate", isOn: state.isDeterminate)
            Slider(value: state.value, in: 0...1, step: 0.05) {
                Text("Value")
            }
            .disabled(!state.wrappedValue.isDeterminate)
        }

        Section("Style") {
            OptionPicker(title: "Progress View Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: ProgressViewPreviewState) -> String {
        var lines: [String]

        if state.isDeterminate {
            lines = [
                "ProgressView(value: \(SwiftUICode.doubleLiteral(state.value)), total: 1) {",
                "    Text(\(SwiftUICode.stringLiteral(state.label)))",
                "}"
            ]
        } else {
            lines = ["ProgressView(\(SwiftUICode.stringLiteral(state.label)))"]
        }

        if state.style != .automatic {
            lines.append(".progressViewStyle(.\(state.style.rawValue))")
        }

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return lines.joined(separator: "\n")
    }

    @ViewBuilder
    private func baseProgressView(_ state: ProgressViewPreviewState) -> some View {
        if state.isDeterminate {
            ProgressView(value: state.value, total: 1) {
                Text(state.label)
            }
        } else {
            ProgressView(state.label)
        }
    }

    @ViewBuilder
    private func styledProgressView(_ state: ProgressViewPreviewState) -> some View {
        switch state.style {
        case .automatic:
            baseProgressView(state)
                .progressViewStyle(.automatic)
        case .circular:
            baseProgressView(state)
                .progressViewStyle(.circular)
        case .linear:
            baseProgressView(state)
                .progressViewStyle(.linear)
        }
    }
}

struct ProgressViewPreviewState {
    var label = "Loading"
    var value = 0.65
    var isDeterminate = true
    var style = ProgressViewStyleOption.linear
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

enum ProgressViewStyleOption: String, PreviewOption {
    case automatic
    case circular
    case linear

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .circular:
            "Circular"
        case .linear:
            "Linear"
        }
    }
}

struct GaugePreviewControl: ControlPreviewDefinition {
    let id = "gauge"
    let title = "Gauge"
    let category = ControlCategory.controls
    let systemImage = "gauge"
    let keywords = ["meter", "value", "progress", "range"]

    func makeState() -> GaugePreviewState {
        GaugePreviewState()
    }

    func makePreview(state: Binding<GaugePreviewState>) -> some View {
        gauge(state.wrappedValue)
            .tint(state.wrappedValue.color.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 260)
    }

    func makeInspector(state: Binding<GaugePreviewState>) -> some View {
        Section("Content") {
            TextField("Label", text: state.label)
            Slider(value: state.value, in: 0...1, step: 0.05) {
                Text("Value")
            }
            LabeledContent("Value", value: "\(Int(state.wrappedValue.value * 100))%")
        }

        Section("Style") {
            OptionPicker(title: "Gauge Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: GaugePreviewState) -> String {
        var lines = [
            "Gauge(value: \(SwiftUICode.doubleLiteral(state.value)), in: 0...1) {",
            "    Text(\(SwiftUICode.stringLiteral(state.label)))",
            "} currentValueLabel: {",
            "    Text(\"\(Int(state.value * 100))%\")",
            "}"
        ]

        if state.style != .automatic {
            lines.append(".gaugeStyle(.\(state.style.rawValue))")
        }

        lines.append(".tint(.\(state.color.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return lines.joined(separator: "\n")
    }

    @ViewBuilder
    private func gauge(_ state: GaugePreviewState) -> some View {
        let base = Gauge(value: state.value, in: 0...1) {
            Text(state.label)
        } currentValueLabel: {
            Text("\(Int(state.value * 100))%")
        }

        switch state.style {
        case .automatic:
            base.gaugeStyle(.automatic)
        case .accessoryCircular:
            base.gaugeStyle(.accessoryCircular)
        case .linearCapacity:
            base.gaugeStyle(.linearCapacity)
        }
    }
}

struct GaugePreviewState {
    var label = "Capacity"
    var value = 0.72
    var style = GaugeStyleOption.accessoryCircular
    var color = PreviewColorOption.green
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

enum GaugeStyleOption: String, PreviewOption {
    case automatic
    case accessoryCircular
    case linearCapacity

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .accessoryCircular:
            "Accessory Circular"
        case .linearCapacity:
            "Linear Capacity"
        }
    }
}
