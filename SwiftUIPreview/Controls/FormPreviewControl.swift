import SwiftUI

struct FormPreviewControl: ControlPreviewDefinition {
    let id = "form"
    let title = "Form"
    let category = ControlCategory.containers
    let systemImage = "list.clipboard"
    let keywords = ["fields", "section", "settings", "grouped", "columns"]

    func makeState() -> FormPreviewState {
        FormPreviewState()
    }

    func makePreview(state: Binding<FormPreviewState>) -> some View {
        styledForm(state: state)
            .tint(state.wrappedValue.tint.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 420)
    }

    func makeInspector(state: Binding<FormPreviewState>) -> some View {
        Section("Content") {
            TextField("Name", text: state.name)
            Toggle("Show Advanced Section", isOn: state.showsAdvancedSection)
        }

        Section("Style") {
            OptionPicker(title: "Form Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: FormPreviewState) -> String {
        var formLines = [
            "Form {",
            "    Section(\"Profile\") {",
            "        TextField(\"Name\", text: $name)",
            "        Picker(\"Role\", selection: $role) {",
            "            Text(\"Developer\").tag(\"Developer\")",
            "            Text(\"Designer\").tag(\"Designer\")",
            "            Text(\"Reviewer\").tag(\"Reviewer\")",
            "        }",
            "    }",
            "",
            "    Section(\"Preferences\") {",
            "        Toggle(\"Send Updates\", isOn: $sendsUpdates)",
            "        Stepper(\"Refresh: \\(refreshInterval) min\", value: $refreshInterval, in: 5...60, step: 5)",
            "    }"
        ]

        if state.showsAdvancedSection {
            formLines.append(contentsOf: [
                "",
                "    Section(\"Advanced\") {",
                "        Toggle(\"Developer Mode\", isOn: $developerMode)",
                "    }"
            ])
        }

        formLines.append("}")

        if state.style != .automatic {
            formLines.append(".formStyle(.\(state.style.rawValue))")
        }

        formLines.append(".tint(.\(state.tint.codeName))")
        formLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        formLines.append(".frame(width: 420)")

        return SwiftUICode.view(
            named: "FormExample",
            declarations: [
                "@State private var name = \(SwiftUICode.stringLiteral(state.name))",
                "@State private var role = \(SwiftUICode.stringLiteral(state.role.title))",
                "@State private var sendsUpdates = \(state.sendsUpdates)",
                "@State private var refreshInterval = \(state.refreshInterval)",
                "@State private var developerMode = \(state.developerMode)"
            ],
            body: formLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledForm(state: Binding<FormPreviewState>) -> some View {
        switch state.wrappedValue.style {
        case .automatic:
            form(state: state)
                .formStyle(.automatic)
        case .grouped:
            form(state: state)
                .formStyle(.grouped)
        case .columns:
            form(state: state)
                .formStyle(.columns)
        }
    }

    private func form(state: Binding<FormPreviewState>) -> some View {
        Form {
            Section("Profile") {
                TextField("Name", text: state.name)
                Picker("Role", selection: state.role) {
                    ForEach(FormRoleOption.allCases) { role in
                        Text(role.title).tag(role)
                    }
                }
            }

            Section("Preferences") {
                Toggle("Send Updates", isOn: state.sendsUpdates)
                Stepper("Refresh: \(state.wrappedValue.refreshInterval) min", value: state.refreshInterval, in: 5...60, step: 5)
            }

            if state.wrappedValue.showsAdvancedSection {
                Section("Advanced") {
                    Toggle("Developer Mode", isOn: state.developerMode)
                }
            }
        }
    }
}

struct FormPreviewState {
    var name = "SwiftUIPreview"
    var role = FormRoleOption.developer
    var sendsUpdates = true
    var refreshInterval = 15
    var developerMode = false
    var showsAdvancedSection = true
    var style = FormStyleOption.grouped
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

enum FormRoleOption: String, PreviewOption {
    case developer
    case designer
    case reviewer

    var title: String {
        switch self {
        case .developer:
            "Developer"
        case .designer:
            "Designer"
        case .reviewer:
            "Reviewer"
        }
    }
}

enum FormStyleOption: String, PreviewOption {
    case automatic
    case grouped
    case columns

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .grouped:
            "Grouped"
        case .columns:
            "Columns"
        }
    }
}
