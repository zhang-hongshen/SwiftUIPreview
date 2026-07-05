import SwiftUI

struct GridPreviewControl: ControlPreviewDefinition {
    let id = "grid"
    let title = "Grid"
    let category = ControlCategory.containers
    let systemImage = "square.grid.3x3"
    let keywords = ["columns", "rows", "layout", "container"]

    func makeState() -> GridPreviewState {
        GridPreviewState()
    }

    func makePreview(state: Binding<GridPreviewState>) -> some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            ForEach(0..<state.wrappedValue.rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<state.wrappedValue.columns, id: \.self) { column in
                        Text("\(row + 1),\(column + 1)")
                            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
                            .frame(width: 56, height: 40)
                            .background(state.wrappedValue.color.color.opacity(0.18), in: RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }

    func makeInspector(state: Binding<GridPreviewState>) -> some View {
        Section("Content") {
            Stepper("Rows: \(state.wrappedValue.rows)", value: state.rows, in: 1...5)
            Stepper("Columns: \(state.wrappedValue.columns)", value: state.columns, in: 1...5)
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: GridPreviewState) -> String {
        var lines = [
            "Grid(horizontalSpacing: 10, verticalSpacing: 10) {",
            "    ForEach(0..<\(state.rows), id: \\.self) { row in",
            "        GridRow {",
            "            ForEach(0..<\(state.columns), id: \\.self) { column in",
            "                Text(\"\\(row + 1),\\(column + 1)\")"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth).map { "                    \($0)" })

        lines.append(contentsOf: [
            "                    .frame(width: 56, height: 40)",
            "                    .background(.\(state.color.codeName).opacity(0.18), in: RoundedRectangle(cornerRadius: 6))",
            "            }",
            "        }",
            "    }",
            "}"
        ])

        return lines.joined(separator: "\n")
    }
}

struct GridPreviewState {
    var rows = 3
    var columns = 3
    var color = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct GroupBoxPreviewControl: ControlPreviewDefinition {
    let id = "group-box"
    let title = "GroupBox"
    let category = ControlCategory.containers
    let systemImage = "square.on.square"
    let keywords = ["group", "container", "section", "label"]

    func makeState() -> GroupBoxPreviewState {
        GroupBoxPreviewState()
    }

    func makePreview(state: Binding<GroupBoxPreviewState>) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                Text(state.wrappedValue.body)
                if state.wrappedValue.showsSecondaryText {
                    Text("Secondary information")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 300, alignment: .leading)
        } label: {
            Label(state.wrappedValue.title, systemImage: state.wrappedValue.systemImage)
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
    }

    func makeInspector(state: Binding<GroupBoxPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("System Image", text: state.systemImage)
            TextField("Body", text: state.body)
            Toggle("Show Secondary Text", isOn: state.showsSecondaryText)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: GroupBoxPreviewState) -> String {
        var bodyLines = [
            "GroupBox {",
            "    VStack(alignment: .leading, spacing: 8) {",
            "        Text(\(SwiftUICode.stringLiteral(state.body)))"
        ]

        if state.showsSecondaryText {
            bodyLines.append(contentsOf: [
                "        Text(\"Secondary information\")",
                "            .foregroundStyle(.secondary)"
            ])
        }

        bodyLines.append(contentsOf: [
            "    }",
            "    .frame(width: 300, alignment: .leading)",
            "} label: {",
            "    Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \(SwiftUICode.stringLiteral(state.systemImage)))",
            "}"
        ])

        bodyLines.append(".tint(.\(state.tint.codeName))")
        bodyLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return bodyLines.joined(separator: "\n")
    }
}

struct GroupBoxPreviewState {
    var title = "Account"
    var systemImage = "person.crop.circle"
    var body = "Signed in with iCloud."
    var showsSecondaryText = true
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct ScrollViewPreviewControl: ControlPreviewDefinition {
    let id = "scroll-view"
    let title = "ScrollView"
    let category = ControlCategory.containers
    let systemImage = "arrow.up.and.down"
    let keywords = ["scroll", "container", "vertical", "horizontal"]

    func makeState() -> ScrollViewPreviewState {
        ScrollViewPreviewState()
    }

    func makePreview(state: Binding<ScrollViewPreviewState>) -> some View {
        ScrollView(state.wrappedValue.axis.axes, showsIndicators: state.wrappedValue.showsIndicators) {
            stack(for: state.wrappedValue)
                .padding(8)
        }
        .frame(width: 340, height: 220)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }

    func makeInspector(state: Binding<ScrollViewPreviewState>) -> some View {
        Section("Content") {
            Stepper("Items: \(state.wrappedValue.itemCount)", value: state.itemCount, in: 3...20)
        }

        Section("Layout") {
            OptionPicker(title: "Axis", selection: state.axis)
            Toggle("Show Indicators", isOn: state.showsIndicators)
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: ScrollViewPreviewState) -> String {
        let stackName = state.axis == .vertical ? "LazyVStack" : "LazyHStack"
        var lines = [
            "ScrollView(.\(state.axis.rawValue), showsIndicators: \(state.showsIndicators ? "true" : "false")) {",
            "    \(stackName)(spacing: 8) {",
            "        ForEach(1...\(state.itemCount), id: \\.self) { index in",
            "            Text(\"Item \\(index)\")"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth).map { "                \($0)" })

        lines.append(contentsOf: [
            "                .frame(width: 96, height: 36)",
            "                .background(.\(state.color.codeName).opacity(0.18), in: RoundedRectangle(cornerRadius: 6))",
            "        }",
            "    }",
            "    .padding(8)",
            "}",
            ".frame(width: 340, height: 220)"
        ])

        return lines.joined(separator: "\n")
    }

    @ViewBuilder
    private func stack(for state: ScrollViewPreviewState) -> some View {
        if state.axis == .vertical {
            LazyVStack(spacing: 8) {
                items(state)
            }
        } else {
            LazyHStack(spacing: 8) {
                items(state)
            }
        }
    }

    private func items(_ state: ScrollViewPreviewState) -> some View {
        ForEach(1...state.itemCount, id: \.self) { index in
            Text("Item \(index)")
                .previewSystemFont(size: state.fontSize, width: state.fontWidth)
                .frame(width: 96, height: 36)
                .background(state.color.color.opacity(0.18), in: RoundedRectangle(cornerRadius: 6))
        }
    }
}

struct ScrollViewPreviewState {
    var itemCount = 12
    var axis = PreviewAxisOption.vertical
    var showsIndicators = true
    var color = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct DisclosureGroupPreviewControl: ControlPreviewDefinition {
    let id = "disclosure-group"
    let title = "DisclosureGroup"
    let category = ControlCategory.containers
    let systemImage = "chevron.right.square"
    let keywords = ["expand", "collapse", "section", "container"]

    func makeState() -> DisclosureGroupPreviewState {
        DisclosureGroupPreviewState()
    }

    func makePreview(state: Binding<DisclosureGroupPreviewState>) -> some View {
        DisclosureGroup(state.wrappedValue.title, isExpanded: state.isExpanded) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(1...state.wrappedValue.rowCount, id: \.self) { index in
                    Label("Item \(index)", systemImage: "doc")
                }
            }
            .padding(.top, 8)
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .frame(width: 320, alignment: .leading)
    }

    func makeInspector(state: Binding<DisclosureGroupPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            Stepper("Rows: \(state.wrappedValue.rowCount)", value: state.rowCount, in: 1...8)
        }

        Section("State") {
            Toggle("Expanded", isOn: state.isExpanded)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: DisclosureGroupPreviewState) -> String {
        var lines = [
            "DisclosureGroup(\(SwiftUICode.stringLiteral(state.title)), isExpanded: $isExpanded) {",
            "    VStack(alignment: .leading, spacing: 8) {",
            "        ForEach(1...\(state.rowCount), id: \\.self) { index in",
            "            Label(\"Item \\(index)\", systemImage: \"doc\")",
            "        }",
            "    }",
            "    .padding(.top, 8)",
            "}"
        ]

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(".frame(width: 320, alignment: .leading)")

        return SwiftUICode.view(
            named: "DisclosureGroupExample",
            declarations: ["@State private var isExpanded = \(state.isExpanded ? "true" : "false")"],
            body: lines.joined(separator: "\n")
        )
    }
}

struct DisclosureGroupPreviewState {
    var title = "Advanced"
    var rowCount = 3
    var isExpanded = true
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}
