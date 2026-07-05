import SwiftUI

struct TablePreviewControl: ControlPreviewDefinition {
    let id = "table"
    let title = "Table"
    let category = ControlCategory.containers
    let systemImage = "tablecells"
    let keywords = ["columns", "rows", "selection", "data", "grid"]

    func makeState() -> TablePreviewState {
        TablePreviewState()
    }

    func makePreview(state: Binding<TablePreviewState>) -> some View {
        Table(rows(for: state.wrappedValue), selection: state.selectedID) {
            TableColumn("Name", value: \.name)

            if state.wrappedValue.showsRoleColumn {
                TableColumn("Role", value: \.role)
            }

            if state.wrappedValue.showsLocationColumn {
                TableColumn("Location", value: \.location)
            }
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .frame(width: 560, height: 240)
    }

    func makeInspector(state: Binding<TablePreviewState>) -> some View {
        Section("Content") {
            Stepper("Rows: \(state.wrappedValue.rowCount)", value: state.rowCount, in: 2...6)
            Toggle("Role Column", isOn: state.showsRoleColumn)
            Toggle("Location Column", isOn: state.showsLocationColumn)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: TablePreviewState) -> String {
        let rows = rows(for: state)
        let declarations = [
            """
            private struct Person: Identifiable, Hashable {
                let id: Int
                let name: String
                let role: String
                let location: String
            }
            """,
            peopleDeclaration(rows),
            "@State private var selection: Person.ID? = \(state.selectedID.map(String.init) ?? "nil")"
        ]

        var tableLines = [
            "Table(people, selection: $selection) {",
            "    TableColumn(\"Name\", value: \\.name)"
        ]

        if state.showsRoleColumn {
            tableLines.append("    TableColumn(\"Role\", value: \\.role)")
        }

        if state.showsLocationColumn {
            tableLines.append("    TableColumn(\"Location\", value: \\.location)")
        }

        tableLines.append("}")
        tableLines.append(".tint(.\(state.tint.codeName))")
        tableLines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        tableLines.append(".frame(width: 560, height: 240)")

        return SwiftUICode.view(
            named: "TableExample",
            declarations: declarations,
            body: tableLines.joined(separator: "\n")
        )
    }

    private func rows(for state: TablePreviewState) -> [SamplePerson] {
        Array(SamplePreviewData.people.prefix(state.rowCount))
    }

    private func peopleDeclaration(_ rows: [SamplePerson]) -> String {
        let peopleLines = rows.map { person in
            "    Person(id: \(person.id), name: \(SwiftUICode.stringLiteral(person.name)), role: \(SwiftUICode.stringLiteral(person.role)), location: \(SwiftUICode.stringLiteral(person.location)))"
        }

        return """
        private let people = [
        \(peopleLines.joined(separator: ",\n"))
        ]
        """
    }
}

struct TablePreviewState {
    var rowCount = 4
    var selectedID: SamplePerson.ID?
    var showsRoleColumn = true
    var showsLocationColumn = true
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}
