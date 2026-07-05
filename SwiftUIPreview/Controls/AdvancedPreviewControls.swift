import SwiftUI
import PhotosUI

struct TimelineViewPreviewControl: ControlPreviewDefinition {
    let id = "timeline-view"
    let title = "TimelineView"
    let category = ControlCategory.advanced
    let systemImage = "clock.arrow.circlepath"
    let keywords = ["time", "animation", "schedule", "advanced"]

    func makeState() -> TimelineViewPreviewState {
        TimelineViewPreviewState()
    }

    func makePreview(state: Binding<TimelineViewPreviewState>) -> some View {
        TimelineView(.periodic(from: .now, by: state.wrappedValue.interval)) { context in
            VStack(spacing: 8) {
                Text(context.date, style: .time)
                    .font(.system(state.wrappedValue.fontSize.textStyle, design: .monospaced))
                    .fontWidth(state.wrappedValue.fontWidth.width)
                    .foregroundStyle(state.wrappedValue.color.color)
                Text("Updates every \(Int(state.wrappedValue.interval))s")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 280, height: 120)
    }

    func makeInspector(state: Binding<TimelineViewPreviewState>) -> some View {
        Section("Schedule") {
            Slider(value: state.interval, in: 1...10, step: 1) {
                Text("Interval")
            }
            LabeledContent("Interval", value: "\(Int(state.wrappedValue.interval))s")
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: TimelineViewPreviewState) -> String {
        var lines = [
            "TimelineView(.periodic(from: .now, by: \(SwiftUICode.doubleLiteral(state.interval)))) { context in",
            "    VStack(spacing: 8) {",
            "        Text(context.date, style: .time)",
            "            .font(.system(\(state.fontSize.code), design: .monospaced))"
        ]

        if state.fontWidth != .standard {
            lines.append("            .fontWidth(\(state.fontWidth.code))")
        }

        lines.append(contentsOf: [
            "            .foregroundStyle(.\(state.color.codeName))",
            "        Text(\"Updates every \(Int(state.interval))s\")",
            "            .foregroundStyle(.secondary)",
            "    }",
            "}"
        ])

        return lines.joined(separator: "\n")
    }
}

struct TimelineViewPreviewState {
    var interval = 1.0
    var color = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.title
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct GeometryReaderPreviewControl: ControlPreviewDefinition {
    let id = "geometry-reader"
    let title = "GeometryReader"
    let category = ControlCategory.advanced
    let systemImage = "ruler"
    let keywords = ["layout", "size", "proxy", "advanced"]

    func makeState() -> GeometryReaderPreviewState {
        GeometryReaderPreviewState()
    }

    func makePreview(state: Binding<GeometryReaderPreviewState>) -> some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(state.wrappedValue.color.color.opacity(0.18))
                Text("\(Int(proxy.size.width)) x \(Int(proxy.size.height))")
                    .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            }
        }
        .frame(width: state.wrappedValue.width, height: state.wrappedValue.height)
    }

    func makeInspector(state: Binding<GeometryReaderPreviewState>) -> some View {
        Section("Layout") {
            Slider(value: state.width, in: 160...420, step: 10) {
                Text("Width")
            }
            Slider(value: state.height, in: 100...280, step: 10) {
                Text("Height")
            }
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: GeometryReaderPreviewState) -> String {
        var lines = [
            "GeometryReader { proxy in",
            "    ZStack {",
            "        RoundedRectangle(cornerRadius: 8)",
            "            .fill(.\(state.color.codeName).opacity(0.18))",
            "        Text(\"\\(Int(proxy.size.width)) x \\(Int(proxy.size.height))\")"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth).map { "            \($0)" })
        lines.append(contentsOf: [
            "    }",
            "}",
            ".frame(width: \(SwiftUICode.doubleLiteral(state.width)), height: \(SwiftUICode.doubleLiteral(state.height)))"
        ])

        return lines.joined(separator: "\n")
    }
}

struct GeometryReaderPreviewState {
    var width = 280.0
    var height = 160.0
    var color = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.headline
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct AnyLayoutPreviewControl: ControlPreviewDefinition {
    let id = "any-layout"
    let title = "AnyLayout"
    let category = ControlCategory.advanced
    let systemImage = "square.grid.2x2"
    let keywords = ["layout", "type erasure", "advanced"]

    func makeState() -> AnyLayoutPreviewState {
        AnyLayoutPreviewState()
    }

    func makePreview(state: Binding<AnyLayoutPreviewState>) -> some View {
        let layout = state.wrappedValue.layout == .vertical
            ? AnyLayout(VStackLayout(spacing: 10))
            : AnyLayout(HStackLayout(spacing: 10))

        return layout {
            ForEach(1...state.wrappedValue.itemCount, id: \.self) { index in
                Text("\(index)")
                    .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
                    .frame(width: 48, height: 48)
                    .background(state.wrappedValue.color.color.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    func makeInspector(state: Binding<AnyLayoutPreviewState>) -> some View {
        Section("Layout") {
            OptionPicker(title: "Layout", selection: state.layout)
            Stepper("Items: \(state.wrappedValue.itemCount)", value: state.itemCount, in: 2...6)
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: AnyLayoutPreviewState) -> String {
        let layoutExpression = state.layout == .vertical
            ? "AnyLayout(VStackLayout(spacing: 10))"
            : "AnyLayout(HStackLayout(spacing: 10))"

        var lines = [
            "let layout = \(layoutExpression)",
            "",
            "layout {",
            "    ForEach(1...\(state.itemCount), id: \\.self) { index in",
            "        Text(\"\\(index)\")"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth).map { "            \($0)" })
        lines.append(contentsOf: [
            "            .frame(width: 48, height: 48)",
            "            .background(.\(state.color.codeName).opacity(0.18), in: RoundedRectangle(cornerRadius: 8))",
            "    }",
            "}"
        ])

        return lines.joined(separator: "\n")
    }
}

struct AnyLayoutPreviewState {
    var layout = PreviewAxisOption.horizontal
    var itemCount = 4
    var color = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct ShareLinkPreviewControl: ControlPreviewDefinition {
    let id = "share-link"
    let title = "ShareLink"
    let category = ControlCategory.advanced
    let systemImage = "square.and.arrow.up"
    let keywords = ["share", "export", "advanced"]

    func makeState() -> ShareLinkPreviewState {
        ShareLinkPreviewState()
    }

    func makePreview(state: Binding<ShareLinkPreviewState>) -> some View {
        ShareLink(item: URL(string: state.wrappedValue.urlString) ?? URL(string: "https://developer.apple.com")!) {
            Label(state.wrappedValue.title, systemImage: state.wrappedValue.systemImage)
        }
        .controlSize(state.wrappedValue.controlSize.controlSize)
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
    }

    func makeInspector(state: Binding<ShareLinkPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("URL", text: state.urlString)
            TextField("System Image", text: state.systemImage)
        }

        Section("Style") {
            OptionPicker(title: "Control Size", selection: state.controlSize)
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: ShareLinkPreviewState) -> String {
        var lines = [
            "ShareLink(item: URL(string: \(SwiftUICode.stringLiteral(state.urlString)))!) {",
            "    Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \(SwiftUICode.stringLiteral(state.systemImage)))",
            "}"
        ]

        if state.controlSize != .regular {
            lines.append(".controlSize(.\(state.controlSize.rawValue))")
        }

        lines.append(".tint(.\(state.tint.codeName))")
        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return lines.joined(separator: "\n")
    }
}

struct ShareLinkPreviewState {
    var title = "Share Link"
    var urlString = "https://developer.apple.com/documentation/swiftui/sharelink"
    var systemImage = "square.and.arrow.up"
    var controlSize = PreviewControlSizeOption.regular
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct PhotosPickerPreviewControl: ControlPreviewDefinition {
    let id = "photos-picker"
    let title = "PhotosPicker"
    let category = ControlCategory.advanced
    let systemImage = "photo.stack"
    let keywords = ["photos", "media", "picker", "advanced"]

    func makeState() -> PhotosPickerPreviewState {
        PhotosPickerPreviewState()
    }

    func makePreview(state: Binding<PhotosPickerPreviewState>) -> some View {
        PhotosPicker(selection: state.selection, matching: state.wrappedValue.filter.matching) {
            Label(state.wrappedValue.title, systemImage: state.wrappedValue.systemImage)
        }
        .tint(state.wrappedValue.tint.color)
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
    }

    func makeInspector(state: Binding<PhotosPickerPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("System Image", text: state.systemImage)
        }

        Section("Filter") {
            OptionPicker(title: "Matching", selection: state.filter)
        }

        Section("Style") {
            OptionPicker(title: "Tint", selection: state.tint)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: PhotosPickerPreviewState) -> String {
        var lines = [
            "PhotosPicker(selection: $selection, matching: \(state.filter.codeValue)) {",
            "    Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \(SwiftUICode.stringLiteral(state.systemImage)))",
            "}",
            ".tint(.\(state.tint.codeName))"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        return """
        import SwiftUI
        import PhotosUI

        struct PhotosPickerExample: View {
            @State private var selection: PhotosPickerItem?

            var body: some View {
        \(SwiftUICode.indented(lines.joined(separator: "\n"), level: 2))
            }
        }
        """
    }
}

struct PhotosPickerPreviewState {
    var title = "Choose Photo"
    var systemImage = "photo"
    var filter = PhotosPickerFilterOption.images
    var selection: PhotosPickerItem?
    var tint = PreviewColorOption.blue
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

enum PhotosPickerFilterOption: String, PreviewOption {
    case images
    case videos
    case any

    var title: String {
        switch self {
        case .images:
            "Images"
        case .videos:
            "Videos"
        case .any:
            "Any"
        }
    }

    var matching: PHPickerFilter {
        switch self {
        case .images:
            .images
        case .videos:
            .videos
        case .any:
            .any(of: [.images, .videos])
        }
    }

    var codeValue: String {
        switch self {
        case .images:
            ".images"
        case .videos:
            ".videos"
        case .any:
            ".any(of: [.images, .videos])"
        }
    }
}
