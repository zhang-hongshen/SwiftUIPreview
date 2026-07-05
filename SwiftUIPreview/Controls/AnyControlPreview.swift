import SwiftUI

struct AnyControlPreview: Identifiable {
    let id: String
    let title: String
    let category: ControlCategory
    let systemImage: String
    let keywords: [String]
    let minimumMacOSVersion: MacOSVersion

    private let stateBuilder: () -> Any
    private let previewBuilder: (Binding<Any>) -> AnyView
    private let inspectorBuilder: (Binding<Any>) -> AnyView
    private let codeBuilder: (Any) -> String

    init<Definition: ControlPreviewDefinition>(_ definition: Definition) {
        id = definition.id
        title = definition.title
        category = definition.category
        systemImage = definition.systemImage
        keywords = definition.keywords
        minimumMacOSVersion = definition.minimumMacOSVersion
        stateBuilder = definition.makeState

        previewBuilder = { state in
            let typedState = Self.typedBinding(
                from: state,
                defaultValue: definition.makeState
            )

            return AnyView(definition.makePreview(state: typedState))
        }

        inspectorBuilder = { state in
            let typedState = Self.typedBinding(
                from: state,
                defaultValue: definition.makeState
            )

            return AnyView(definition.makeInspector(state: typedState))
        }

        codeBuilder = { state in
            let typedState = state as? Definition.PreviewState ?? definition.makeState()
            return definition.makeCode(state: typedState)
        }
    }

    func makeState() -> Any {
        stateBuilder()
    }

    func makePreview(state: Binding<Any>) -> AnyView {
        previewBuilder(state)
    }

    func makeInspector(state: Binding<Any>) -> AnyView {
        inspectorBuilder(state)
    }

    func makeCode(state: Any) -> String {
        codeBuilder(state)
    }

    func matches(_ query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            return true
        }

        let searchableText = ([title, category.rawValue] + keywords)
            .joined(separator: " ")
            .localizedLowercase

        return searchableText.contains(trimmedQuery.localizedLowercase)
    }

    private static func typedBinding<State>(
        from state: Binding<Any>,
        defaultValue: @escaping () -> State
    ) -> Binding<State> {
        Binding<State>(
            get: {
                state.wrappedValue as? State ?? defaultValue()
            },
            set: { newValue in
                state.wrappedValue = newValue
            }
        )
    }
}
