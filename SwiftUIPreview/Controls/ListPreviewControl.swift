import SwiftUI

struct ListPreviewControl: ControlPreviewDefinition {
    let id = "list"
    let title = "List"
    let category = ControlCategory.containers
    let systemImage = "list.bullet"
    let keywords = ["rows", "selection", "sidebar", "inset", "plain", "collection"]

    func makeState() -> ListPreviewState {
        ListPreviewState()
    }

    func makePreview(state: Binding<ListPreviewState>) -> some View {
        styledList(state: state)
            .tint(state.wrappedValue.tint.color)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 340, height: 230)
    }

    func makeInspector(state: Binding<ListPreviewState>) -> some View {
        Section("Content") {
            Stepper("Rows: \(state.wrappedValue.rowCount)", value: state.rowCount, in: 3...8)
            Toggle("Show Detail", isOn: state.showsDetail)
            Toggle("Selectable", isOn: state.isSelectable)
        }

        Section("Style") {
            OptionPicker(title: "List Style", selection: state.style)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: ListPreviewState) -> String {
        let rows = Array(SamplePreviewData.listItems.prefix(state.rowCount))
        var declarations = [
            """
            private struct Item: Identifiable, Hashable {
                let id: Int
                let title: String
                let detail: String
            }
            """,
            listItemsDeclaration(rows)
        ]

        if state.isSelectable {
            declarations.append("@State private var selection: Item.ID? = \(state.selectedID.map(String.init) ?? "nil")")
        }

        var listLines = [
            state.isSelectable ? "List(selection: $selection) {" : "List {",
            "    ForEach(items) { item in",
            "        VStack(alignment: .leading, spacing: 2) {",
            "            Text(item.title)"
        ]

        if state.showsDetail {
            listLines.append(contentsOf: [
                "",
                "            Text(item.detail)",
                "                .font(.caption)",
                "                .foregroundStyle(.secondary)"
            ])
        }

        listLines.append("        }")

        if state.isSelectable {
            listLines.append("        .tag(item.id)")
        }

        listLines.append("    }")
        listLines.append("}")

        if state.style != .automatic {
            listLines.append(".listStyle(.\(state.style.codeName))")
        }

        listLines.append(".tint(.\(state.tint.codeName))")
        listLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        listLines.append(".frame(width: 340, height: 230)")

        return SwiftUICode.view(
            named: "ListExample",
            declarations: declarations,
            body: listLines.joined(separator: "\n")
        )
    }

    @ViewBuilder
    private func styledList(state: Binding<ListPreviewState>) -> some View {
        let snapshot = state.wrappedValue

        switch snapshot.style {
        case .automatic:
            list(state: state)
                .listStyle(.automatic)
        case .sidebar:
            list(state: state)
                .listStyle(.sidebar)
        case .inset:
            list(state: state)
                .listStyle(.inset)
        case .plain:
            list(state: state)
                .listStyle(.plain)
        }
    }

    private func list(state: Binding<ListPreviewState>) -> some View {
        let snapshot = state.wrappedValue
        let rows = Array(SamplePreviewData.listItems.prefix(snapshot.rowCount))

        return List(selection: snapshot.isSelectable ? state.selectedID : .constant(nil)) {
            ForEach(rows) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.title)

                    if snapshot.showsDetail {
                        Text(row.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .tag(row.id)
            }
        }
    }

    private func listItemsDeclaration(_ rows: [SampleListItem]) -> String {
        let itemLines = rows.map { row in
            "    Item(id: \(row.id), title: \(SwiftUICode.stringLiteral(row.title)), detail: \(SwiftUICode.stringLiteral(row.detail)))"
        }

        return """
        private let items = [
        \(itemLines.joined(separator: ",\n"))
        ]
        """
    }
}

struct ListPreviewState {
    var rowCount = 5
    var selectedID: SampleListItem.ID?
    var showsDetail = true
    var isSelectable = true
    var style = ListStyleOption.sidebar
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

enum ListStyleOption: String, PreviewOption {
    case automatic
    case sidebar
    case inset
    case plain

    var title: String {
        switch self {
        case .automatic:
            "Automatic"
        case .sidebar:
            "Sidebar"
        case .inset:
            "Inset"
        case .plain:
            "Plain"
        }
    }
}

private extension ListStyleOption {
    var codeName: String {
        switch self {
        case .automatic:
            "automatic"
        case .sidebar:
            "sidebar"
        case .inset:
            "inset"
        case .plain:
            "plain"
        }
    }
}
