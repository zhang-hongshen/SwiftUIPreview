import SwiftUI

struct ControlSidebarView: View {
    let controls: [AnyControlPreview]
    @Binding var searchText: String
    @Binding var selection: String?

    private var filteredControls: [AnyControlPreview] {
        controls.filter { $0.matches(searchText) }
    }

    var body: some View {
        List(selection: $selection) {
            ForEach(ControlCategory.allCases) { category in
                let categoryControls = filteredControls.filter { $0.category == category }

                if !categoryControls.isEmpty {
                    Section(category.rawValue) {
                        ForEach(categoryControls) { control in
                            Label {
                                Text(control.title)
                                    .lineLimit(1)
                            } icon: {
                                Image(systemName: control.systemImage)
                                    .foregroundStyle(.secondary)
                            }
                            .tag(control.id)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, placement: .sidebar, prompt: "Search controls")
    }
}
