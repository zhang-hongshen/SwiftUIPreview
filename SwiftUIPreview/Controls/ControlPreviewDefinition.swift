import SwiftUI

protocol ControlPreviewDefinition: Identifiable {
    associatedtype PreviewState
    associatedtype PreviewBody: View
    associatedtype InspectorBody: View

    var id: String { get }
    var title: String { get }
    var category: ControlCategory { get }
    var systemImage: String { get }
    var keywords: [String] { get }
    var minimumMacOSVersion: MacOSVersion { get }

    func makeState() -> PreviewState

    @ViewBuilder
    func makePreview(state: Binding<PreviewState>) -> PreviewBody

    @ViewBuilder
    func makeInspector(state: Binding<PreviewState>) -> InspectorBody

    func makeCode(state: PreviewState) -> String
}

extension ControlPreviewDefinition {
    var minimumMacOSVersion: MacOSVersion {
        MacOSVersion(major: 13)
    }
}
