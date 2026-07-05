import SwiftUI

struct ContentView: View {
    private let controls: [AnyControlPreview]

    @State private var selectedControlID: String?
    @State private var previewStates: [String: Any]
    @State private var searchText = ""
    @State private var isInspectorPresented = true

    init(controls: [AnyControlPreview] = ControlRegistry.defaultControls) {
        self.controls = controls
        _selectedControlID = State(initialValue: controls.first?.id)
        _previewStates = State(
            initialValue: Dictionary(uniqueKeysWithValues: controls.map { ($0.id, $0.makeState()) })
        )
    }

    var body: some View {
        NavigationSplitView {
            ControlSidebarView(
                controls: controls,
                searchText: $searchText,
                selection: $selectedControlID
            )
            .navigationSplitViewColumnWidth(min: 190, ideal: 230, max: 290)
        } detail: {
            detailContent
                .navigationTitle(selectedControl?.title ?? "SwiftUIPreview")
                .toolbar {
                    ToolbarItem {
                        Button {
                            isInspectorPresented.toggle()
                        } label: {
                            Image(systemName: "sidebar.trailing")
                        }
                        .help("Toggle Inspector")
                    }
                }
                .inspector(isPresented: $isInspectorPresented) {
                    if let selectedControl {
                        ControlInspectorView(
                            control: selectedControl,
                            state: stateBinding(for: selectedControl)
                        )
                    }
                }
        }
    }

    @ViewBuilder
    private var detailContent: some View {
        if let selectedControl {
            ControlDetailView(
                control: selectedControl,
                state: stateBinding(for: selectedControl)
            )
        } else {
            ContentUnavailableView(
                "Select a Control",
                systemImage: "rectangle.stack"
            )
        }
    }

    private var selectedControl: AnyControlPreview? {
        controls.first { $0.id == selectedControlID } ?? controls.first
    }

    private func stateBinding(for control: AnyControlPreview) -> Binding<Any> {
        Binding<Any>(
            get: {
                previewStates[control.id] ?? control.makeState()
            },
            set: { newValue in
                previewStates[control.id] = newValue
            }
        )
    }
}

#Preview {
    ContentView()
}
