import SwiftUI

struct TextPreviewControl: ControlPreviewDefinition {
    let id = "text"
    let title = "Text"
    let category = ControlCategory.textContent
    let systemImage = "textformat"
    let keywords = ["typography", "string", "font", "content", "label"]

    func makeState() -> TextPreviewState {
        TextPreviewState()
    }

    func makePreview(state: Binding<TextPreviewState>) -> some View {
        textView(state.wrappedValue)
    }

    func makeInspector(state: Binding<TextPreviewState>) -> some View {
        Section("Content") {
            TextField("Text", text: state.text)
        }

        Section("Style") {
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            Toggle("Bold", isOn: state.isBold)
            OptionPicker(title: "Color", selection: state.color)
            Toggle("Selectable", isOn: state.isSelectable)
        }
    }

    func makeCode(state: TextPreviewState) -> String {
        var lines = ["Text(\(SwiftUICode.stringLiteral(state.text)))"]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.isBold {
            lines.append(".fontWeight(.semibold)")
        }

        if state.color != .primary {
            lines.append(".foregroundStyle(.\(state.color.codeName))")
        }

        if state.isSelectable {
            lines.append(".textSelection(.enabled)")
        }

        return lines.joined(separator: "\n")
    }

    @ViewBuilder
    private func textView(_ state: TextPreviewState) -> some View {
        let text = Text(state.text)
            .previewSystemFont(size: state.fontSize, width: state.fontWidth)
            .fontWeight(state.isBold ? .semibold : .regular)
            .foregroundStyle(state.color.color)

        if state.isSelectable {
            text.textSelection(.enabled)
        } else {
            text.textSelection(.disabled)
        }
    }
}

struct TextPreviewState {
    var text = "Hello, SwiftUI"
    var fontSize = PreviewSystemFontSizeOption.title
    var fontWidth = PreviewSystemFontWidthOption.standard
    var isBold = false
    var color = PreviewColorOption.blue
    var isSelectable = true
}

struct LabelPreviewControl: ControlPreviewDefinition {
    let id = "label"
    let title = "Label"
    let category = ControlCategory.textContent
    let systemImage = "tag"
    let keywords = ["text", "icon", "title", "symbol"]

    func makeState() -> LabelPreviewState {
        LabelPreviewState()
    }

    func makePreview(state: Binding<LabelPreviewState>) -> some View {
        label(state.wrappedValue)
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .foregroundStyle(state.wrappedValue.color.color)
    }

    func makeInspector(state: Binding<LabelPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("System Image", text: state.systemImage)
        }

        Section("Style") {
            OptionPicker(title: "Label Style", selection: state.style)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            OptionPicker(title: "Color", selection: state.color)
        }
    }

    func makeCode(state: LabelPreviewState) -> String {
        var lines = [
            "Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \(SwiftUICode.stringLiteral(state.systemImage)))"
        ]

        if state.style != .titleAndIcon {
            lines.append(".labelStyle(.\(state.style.rawValue))")
        }

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.color != .primary {
            lines.append(".foregroundStyle(.\(state.color.codeName))")
        }

        return lines.joined(separator: "\n")
    }

    @ViewBuilder
    private func label(_ state: LabelPreviewState) -> some View {
        let base = Label(state.title, systemImage: state.systemImage)

        switch state.style {
        case .titleAndIcon:
            base.labelStyle(.titleAndIcon)
        case .iconOnly:
            base.labelStyle(.iconOnly)
        case .titleOnly:
            base.labelStyle(.titleOnly)
        }
    }
}

struct LabelPreviewState {
    var title = "Downloads"
    var systemImage = "tray.and.arrow.down"
    var style = LabelStyleOption.titleAndIcon
    var fontSize = PreviewSystemFontSizeOption.title3
    var fontWidth = PreviewSystemFontWidthOption.standard
    var color = PreviewColorOption.blue
}

enum LabelStyleOption: String, PreviewOption {
    case titleAndIcon
    case iconOnly
    case titleOnly

    var title: String {
        switch self {
        case .titleAndIcon:
            "Title and Icon"
        case .iconOnly:
            "Icon Only"
        case .titleOnly:
            "Title Only"
        }
    }
}

struct ImagePreviewControl: ControlPreviewDefinition {
    let id = "image"
    let title = "Image"
    let category = ControlCategory.textContent
    let systemImage = "photo"
    let keywords = ["asset", "symbol", "picture", "content"]

    func makeState() -> ImagePreviewState {
        ImagePreviewState()
    }

    func makePreview(state: Binding<ImagePreviewState>) -> some View {
        Image(systemName: state.wrappedValue.systemImage)
            .font(.system(size: state.wrappedValue.size))
            .foregroundStyle(state.wrappedValue.color.color)
            .symbolRenderingMode(state.wrappedValue.isHierarchical ? .hierarchical : .monochrome)
    }

    func makeInspector(state: Binding<ImagePreviewState>) -> some View {
        Section("Content") {
            TextField("System Image", text: state.systemImage)
        }

        Section("Style") {
            Slider(value: state.size, in: 24...120, step: 4) {
                Text("Size")
            }
            LabeledContent("Size", value: "\(Int(state.wrappedValue.size)) pt")
            OptionPicker(title: "Color", selection: state.color)
            Toggle("Hierarchical Rendering", isOn: state.isHierarchical)
        }
    }

    func makeCode(state: ImagePreviewState) -> String {
        var lines = [
            "Image(systemName: \(SwiftUICode.stringLiteral(state.systemImage)))",
            ".font(.system(size: \(SwiftUICode.doubleLiteral(state.size))))",
            ".foregroundStyle(.\(state.color.codeName))"
        ]

        if state.isHierarchical {
            lines.append(".symbolRenderingMode(.hierarchical)")
        }

        return lines.joined(separator: "\n")
    }
}

struct ImagePreviewState {
    var systemImage = "swift"
    var size = 64.0
    var color = PreviewColorOption.orange
    var isHierarchical = false
}

struct AsyncImagePreviewControl: ControlPreviewDefinition {
    let id = "async-image"
    let title = "AsyncImage"
    let category = ControlCategory.textContent
    let systemImage = "photo.on.rectangle"
    let keywords = ["remote", "url", "download", "image", "network"]

    func makeState() -> AsyncImagePreviewState {
        AsyncImagePreviewState()
    }

    func makePreview(state: Binding<AsyncImagePreviewState>) -> some View {
        AsyncImage(url: URL(string: state.wrappedValue.urlString)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: state.wrappedValue.width, height: state.wrappedValue.height)
    }

    func makeInspector(state: Binding<AsyncImagePreviewState>) -> some View {
        Section("Content") {
            TextField("URL", text: state.urlString)
        }

        Section("Layout") {
            Slider(value: state.width, in: 80...360, step: 10) {
                Text("Width")
            }
            Slider(value: state.height, in: 80...240, step: 10) {
                Text("Height")
            }
        }
    }

    func makeCode(state: AsyncImagePreviewState) -> String {
        """
        AsyncImage(url: URL(string: \(SwiftUICode.stringLiteral(state.urlString)))) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: \(SwiftUICode.doubleLiteral(state.width)), height: \(SwiftUICode.doubleLiteral(state.height)))
        """
    }
}

struct AsyncImagePreviewState {
    var urlString = "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png"
    var width = 160.0
    var height = 160.0
}

struct LinkPreviewControl: ControlPreviewDefinition {
    let id = "link"
    let title = "Link"
    let category = ControlCategory.textContent
    let systemImage = "link"
    let keywords = ["url", "open", "website", "text"]

    func makeState() -> LinkPreviewState {
        LinkPreviewState()
    }

    func makePreview(state: Binding<LinkPreviewState>) -> some View {
        Link(destination: URL(string: state.wrappedValue.urlString) ?? URL(string: "https://developer.apple.com")!) {
            Label(state.wrappedValue.title, systemImage: state.wrappedValue.systemImage)
        }
        .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
        .foregroundStyle(state.wrappedValue.color.color)
    }

    func makeInspector(state: Binding<LinkPreviewState>) -> some View {
        Section("Content") {
            TextField("Title", text: state.title)
            TextField("URL", text: state.urlString)
            TextField("System Image", text: state.systemImage)
        }

        Section("Style") {
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
            OptionPicker(title: "Color", selection: state.color)
        }
    }

    func makeCode(state: LinkPreviewState) -> String {
        var lines = [
            "Link(destination: URL(string: \(SwiftUICode.stringLiteral(state.urlString)))!) {",
            "    Label(\(SwiftUICode.stringLiteral(state.title)), systemImage: \(SwiftUICode.stringLiteral(state.systemImage)))",
            "}"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))

        if state.color != .primary {
            lines.append(".foregroundStyle(.\(state.color.codeName))")
        }

        return lines.joined(separator: "\n")
    }
}

struct LinkPreviewState {
    var title = "SwiftUI Documentation"
    var urlString = "https://developer.apple.com/documentation/swiftui"
    var systemImage = "book"
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
    var color = PreviewColorOption.blue
}
