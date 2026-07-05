import SwiftUI

struct NavigationLinkPreviewControl: ControlPreviewDefinition {
    let id = "navigation-link"
    let title = "NavigationLink"
    let category = ControlCategory.navigation
    let systemImage = "arrow.right"
    let keywords = ["navigate", "destination", "link", "selection"]

    func makeState() -> NavigationLinkPreviewState {
        NavigationLinkPreviewState()
    }

    func makePreview(state: Binding<NavigationLinkPreviewState>) -> some View {
        NavigationStack {
            NavigationLink(state.wrappedValue.title, value: state.wrappedValue.destinationTitle)
                .tint(state.wrappedValue.tint.color)
                .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
                .navigationDestination(for: String.self) { destination in
                    Text(destination)
                        .font(.title2)
                        .padding()
                }
                .frame(width: 280, height: 160)
        }
    }

    func makeInspector(state: Binding<NavigationLinkPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("Destination", text: state.destinationTitle)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: NavigationLinkPreviewState) -> String {
        var lines = [
            "NavigationStack {",
            "    NavigationLink(\(SwiftUICode.stringLiteral(state.title)), value: \(SwiftUICode.stringLiteral(state.destinationTitle)))",
            "        .tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth).map { "        \($0)" })
        lines.append(contentsOf: [
            "        .navigationDestination(for: String.self) { destination in",
            "            Text(destination)",
            "        }",
            "}"
        ])

        return lines.joined(separator: "\n")
    }
}

struct NavigationLinkPreviewState {
    var title = "Open Detail"
    var destinationTitle = "Detail View"
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct TabViewPreviewControl: ControlPreviewDefinition {
    let id = "tab-view"
    let title = "TabView"
    let category = ControlCategory.navigation
    let systemImage = "square.split.2x1"
    let keywords = ["tabs", "pages", "selection", "navigation"]

    func makeState() -> TabViewPreviewState {
        TabViewPreviewState()
    }

    func makePreview(state: Binding<TabViewPreviewState>) -> some View {
        TabView(selection: state.selection) {
            ForEach(0..<state.wrappedValue.tabCount, id: \.self) { index in
                Label("Tab \(index + 1)", systemImage: index == 0 ? "star" : "folder")
                    .frame(width: 280, height: 120)
                    .tag(index)
                    .tabItem {
                        Label("Tab \(index + 1)", systemImage: index == 0 ? "star" : "folder")
                    }
            }
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .frame(width: 360, height: 220)
    }

    func makeInspector(state: Binding<TabViewPreviewState>) -> some View {
        Section("Content") {
            Stepper("Tabs: \(state.wrappedValue.tabCount)", value: state.tabCount, in: 2...5)
            Picker("Selection", selection: state.selection) {
                ForEach(0..<state.wrappedValue.tabCount, id: \.self) { index in
                    Text("Tab \(index + 1)").tag(index)
                }
            }
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: TabViewPreviewState) -> String {
        var lines = [
            "TabView(selection: $selection) {",
            "    ForEach(0..<\(state.tabCount), id: \\.self) { index in",
            "        Label(\"Tab \\(index + 1)\", systemImage: index == 0 ? \"star\" : \"folder\")",
            "            .tag(index)",
            "            .tabItem {",
            "                Label(\"Tab \\(index + 1)\", systemImage: index == 0 ? \"star\" : \"folder\")",
            "            }",
            "    }",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return SwiftUICode.view(
            named: "TabViewExample",
            declarations: ["@State private var selection = \(state.selection)"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct TabViewPreviewState {
    var tabCount = 3
    var selection = 0
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct SheetPreviewControl: ControlPreviewDefinition {
    let id = "sheet"
    let title = "Sheet"
    let category = ControlCategory.presentation
    let systemImage = "macwindow"
    let keywords = ["modal", "presentation", "window", "sheet"]

    func makeState() -> SheetPreviewState {
        SheetPreviewState()
    }

    func makePreview(state: Binding<SheetPreviewState>) -> some View {
        Button(state.wrappedValue.buttonTitle) {
            state.wrappedValue.isPresented = true
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .sheet(isPresented: state.isPresented) {
            VStack(spacing: 12) {
                Text(state.wrappedValue.sheetTitle)
                    .font(.title2)
                Text(state.wrappedValue.message)
                    .foregroundStyle(.secondary)
                Button("Close") {
                    state.wrappedValue.isPresented = false
                }
            }
            .padding(32)
            .frame(width: 320)
        }
    }

    func makeInspector(state: Binding<SheetPreviewState>) -> some View {
        Section("Content") {
            TextField("Button Title", text: state.buttonTitle)
            TextField("Sheet Title", text: state.sheetTitle)
            TextField("Message", text: state.message)
        }

        Section("State") {
            Toggle("Presented", isOn: state.isPresented)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: SheetPreviewState) -> String {
        var lines = [
            "Button(\(SwiftUICode.stringLiteral(state.buttonTitle))) {",
            "    isPresented = true",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(contentsOf: [
            ".sheet(isPresented: $isPresented) {",
            "    VStack(spacing: 12) {",
            "        Text(\(SwiftUICode.stringLiteral(state.sheetTitle)))",
            "            .font(.title2)",
            "        Text(\(SwiftUICode.stringLiteral(state.message)))",
            "            .foregroundStyle(.secondary)",
            "        Button(\"Close\") {",
            "            isPresented = false",
            "        }",
            "    }",
            "    .padding(32)",
            "    .frame(width: 320)",
            "}"
        ])

        return SwiftUICode.view(
            named: "SheetExample",
            declarations: ["@State private var isPresented = \(state.isPresented ? "true" : "false")"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct SheetPreviewState {
    var buttonTitle = "Show Sheet"
    var sheetTitle = "Sheet Content"
    var message = "Presented with SwiftUI's sheet modifier."
    var isPresented = false
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct PopoverPreviewControl: ControlPreviewDefinition {
    let id = "popover"
    let title = "Popover"
    let category = ControlCategory.presentation
    let systemImage = "rectangle.on.rectangle"
    let keywords = ["presentation", "floating", "popover"]

    func makeState() -> PopoverPreviewState {
        PopoverPreviewState()
    }

    func makePreview(state: Binding<PopoverPreviewState>) -> some View {
        Button(state.wrappedValue.buttonTitle) {
            state.wrappedValue.isPresented = true
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .popover(isPresented: state.isPresented) {
            Text(state.wrappedValue.message)
                .padding(20)
                .frame(width: 220)
        }
    }

    func makeInspector(state: Binding<PopoverPreviewState>) -> some View {
        Section("Content") {
            TextField("Button Title", text: state.buttonTitle)
            TextField("Message", text: state.message)
        }

        Section("State") {
            Toggle("Presented", isOn: state.isPresented)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: PopoverPreviewState) -> String {
        var lines = [
            "Button(\(SwiftUICode.stringLiteral(state.buttonTitle))) {",
            "    isPresented = true",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(contentsOf: [
            ".popover(isPresented: $isPresented) {",
            "    Text(\(SwiftUICode.stringLiteral(state.message)))",
            "        .padding(20)",
            "        .frame(width: 220)",
            "}"
        ])

        return SwiftUICode.view(
            named: "PopoverExample",
            declarations: ["@State private var isPresented = \(state.isPresented ? "true" : "false")"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct PopoverPreviewState {
    var buttonTitle = "Show Popover"
    var message = "Popover content"
    var isPresented = false
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct AlertPreviewControl: ControlPreviewDefinition {
    let id = "alert"
    let title = "Alert"
    let category = ControlCategory.presentation
    let systemImage = "exclamationmark.triangle"
    let keywords = ["message", "warning", "dialog", "presentation"]

    func makeState() -> AlertPreviewState {
        AlertPreviewState()
    }

    func makePreview(state: Binding<AlertPreviewState>) -> some View {
        Button(state.wrappedValue.buttonTitle) {
            state.wrappedValue.isPresented = true
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .alert(state.wrappedValue.title, isPresented: state.isPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(state.wrappedValue.message)
        }
    }

    func makeInspector(state: Binding<AlertPreviewState>) -> some View {
        Section("Content") {
            TextField("Button Title", text: state.buttonTitle)
            TextField("Title", text: state.title)
            TextField("Message", text: state.message)
        }

        Section("State") {
            Toggle("Presented", isOn: state.isPresented)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: AlertPreviewState) -> String {
        var lines = [
            "Button(\(SwiftUICode.stringLiteral(state.buttonTitle))) {",
            "    isPresented = true",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(contentsOf: [
            ".alert(\(SwiftUICode.stringLiteral(state.title)), isPresented: $isPresented) {",
            "    Button(\"OK\", role: .cancel) {}",
            "} message: {",
            "    Text(\(SwiftUICode.stringLiteral(state.message)))",
            "}"
        ])

        return SwiftUICode.view(
            named: "AlertExample",
            declarations: ["@State private var isPresented = \(state.isPresented ? "true" : "false")"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct AlertPreviewState {
    var buttonTitle = "Show Alert"
    var title = "Discard Changes?"
    var message = "This action cannot be undone."
    var isPresented = false
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct ConfirmationDialogPreviewControl: ControlPreviewDefinition {
    let id = "confirmation-dialog"
    let title = "ConfirmationDialog"
    let category = ControlCategory.presentation
    let systemImage = "checkmark.circle"
    let keywords = ["confirm", "dialog", "actions", "presentation"]

    func makeState() -> ConfirmationDialogPreviewState {
        ConfirmationDialogPreviewState()
    }

    func makePreview(state: Binding<ConfirmationDialogPreviewState>) -> some View {
        Button(state.wrappedValue.buttonTitle) {
            state.wrappedValue.isPresented = true
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .confirmationDialog(state.wrappedValue.title, isPresented: state.isPresented, titleVisibility: .visible) {
            Button("Archive") {}
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(state.wrappedValue.message)
        }
    }

    func makeInspector(state: Binding<ConfirmationDialogPreviewState>) -> some View {
        Section("Content") {
            TextField("Button Title", text: state.buttonTitle)
            TextField("Title", text: state.title)
            TextField("Message", text: state.message)
        }

        Section("State") {
            Toggle("Presented", isOn: state.isPresented)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: ConfirmationDialogPreviewState) -> String {
        var buttonLines = [
            "Button(\(SwiftUICode.stringLiteral(state.buttonTitle))) {",
            "    isPresented = true",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        buttonLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return SwiftUICode.view(
            named: "ConfirmationDialogExample",
            declarations: [
                "@State private var isPresented = \(state.isPresented ? "true" : "false")"
            ],
            body: """
            \(buttonLines.joined(separator: "\n"))
            .confirmationDialog(\(SwiftUICode.stringLiteral(state.title)), isPresented: $isPresented, titleVisibility: .visible) {
                Button("Archive") {}
                Button("Delete", role: .destructive) {}
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(\(SwiftUICode.stringLiteral(state.message)))
            }
            """
        )
    }
}

struct ConfirmationDialogPreviewState {
    var buttonTitle = "Show Actions"
    var title = "Choose an Action"
    var message = "Select how to handle this item."
    var isPresented = false
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}
