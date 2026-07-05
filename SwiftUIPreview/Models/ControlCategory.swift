import Foundation

enum ControlCategory: String, CaseIterable, Identifiable {
    case textContent = "Text & Content"
    case controls = "Controls"
    case containers = "Containers"
    case navigation = "Navigation"
    case presentation = "Presentation"
    case layout = "Layout"
    case graphics = "Graphics"
    case advanced = "Advanced"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .textContent:
            "textformat"
        case .controls:
            "switch.2"
        case .containers:
            "rectangle.stack"
        case .navigation:
            "arrow.triangle.turn.up.right.diamond"
        case .presentation:
            "macwindow.on.rectangle"
        case .layout:
            "ruler"
        case .graphics:
            "paintbrush"
        case .advanced:
            "gearshape.2"
        }
    }
}
