import SwiftUI

struct MenuPreviewControl: ControlPreviewDefinition {
    let id = "menu"
    let title = "Menu"
    let category = ControlCategory.controls
    let systemImage = "filemenu.and.selection"
    let keywords = ["commands", "actions", "dropdown", "options"]

    func makeState() -> MenuPreviewState {
        MenuPreviewState()
    }

    func makePreview(state: Binding<MenuPreviewState>) -> some View {
        Menu {
            ForEach(1...state.wrappedValue.optionCount, id: \.self) { index in
                Button("Option \(index)") {
                }
            }
        } label: {
            if state.wrappedValue.showsIcon {
                Label(state.wrappedValue.title, systemImage: "ellipsis.circle")
            } else {
                Text(state.wrappedValue.title)
            }
        }
        .controlSize(state.wrappedValue.controlSize.controlSize)
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .disabled(state.wrappedValue.isDisabled)
    }

    func makeInspector(state: Binding<MenuPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            Stepper(
                "Options: \(state.wrappedValue.optionCount)",
                value: state.optionCount,
                in: 2...8
            )
            Toggle("Show Icon", isOn: state.showsIcon)
        }

        Section("Style") {
            OptionPicker(title: "Control Size", selection: state.controlSize)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Disabled", isOn: state.isDisabled)
        }
    }

    func makeCode(state: MenuPreviewState) -> String {
        var menuLines = [
            "Menu {",
            "    ForEach(1...\(state.optionCount), id: \\.self) { index in",
            "        Button(\"Option \\(index)\") {",
            "        }",
            "    }",
            "} label: {"
        ]

        if state.showsIcon {
            menuLines.append("    Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \"ellipsis.circle\")")
        } else {
            menuLines.append("    Text(\(SwiftUICode.stringLiteral(state.title)))")
        }

        menuLines.append("}")

        if state.controlSize != .regular {
            menuLines.append(".controlSize(.\(state.controlSize.rawValue))")
        }

        menuLines.append(".tint(.\(state.tint.codeName))")
        menuLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isDisabled {
            menuLines.append(".disabled(true)")
        }

        return SwiftUICode.view(
            named: "MenuExample",
            body: menuLines.joined(separator: "\n")
        )
    }
}

struct MenuPreviewState {
    var title = "Actions"
    var optionCount = 3
    var showsIcon = true
    var controlSize = PreviewControlSizeOption.regular
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isDisabled = false
}
