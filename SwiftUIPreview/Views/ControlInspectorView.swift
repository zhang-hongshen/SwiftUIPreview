import SwiftUI

struct ControlInspectorView: View {
    let control: AnyControlPreview
    @Binding var state: Any

    var body: some View {
        Form {
            Section {
                LabeledContent("Control", value: control.title)
                LabeledContent("Category", value: control.category.rawValue)
            }

            control.makeInspector(state: $state)
        }
        .formStyle(.grouped)
        .inspectorColumnWidth(min: 280, ideal: 320, max: 420)
    }
}
