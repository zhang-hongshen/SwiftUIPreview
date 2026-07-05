import SwiftUI

struct SpacerPreviewControl: ControlPreviewDefinition {
    let id = "spacer"
    let title = "Spacer"
    let category = ControlCategory.layout
    let systemImage = "arrow.left.and.right"
    let keywords = ["space", "flexible", "layout"]

    func makeState() -> SpacerPreviewState {
        SpacerPreviewState()
    }

    func makePreview(state: Binding<SpacerPreviewState>) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(state.wrappedValue.leadingColor.color)
                .frame(width: 72, height: 48)
            Spacer(minLength: state.wrappedValue.minLength)
            RoundedRectangle(cornerRadius: 6)
                .fill(state.wrappedValue.trailingColor.color)
                .frame(width: 72, height: 48)
        }
        .frame(width: 360)
        .padding()
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 8))
    }

    func makeInspector(state: Binding<SpacerPreviewState>) -> some View {
        Section("Layout") {
            Slider(value: state.minLength, in: 0...120, step: 5) {
                Text("Minimum Length")
            }
            LabeledContent("Minimum Length", value: "\(Int(state.wrappedValue.minLength))")
        }

        Section("Style") {
            OptionPicker(title: "Leading Color", selection: state.leadingColor)
            OptionPicker(title: "Trailing Color", selection: state.trailingColor)
        }
    }

    func makeCode(state: SpacerPreviewState) -> String {
        let spacer = state.minLength > 0
            ? "Spacer(minLength: \(SwiftUICode.doubleLiteral(state.minLength)))"
            : "Spacer()"

        return """
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.\(state.leadingColor.codeName))
                .frame(width: 72, height: 48)
            \(spacer)
            RoundedRectangle(cornerRadius: 6)
                .fill(.\(state.trailingColor.codeName))
                .frame(width: 72, height: 48)
        }
        .frame(width: 360)
        """
    }
}

struct SpacerPreviewState {
    var minLength = 24.0
    var leadingColor = PreviewColorOption.blue
    var trailingColor = PreviewColorOption.green
}

struct DividerPreviewControl: ControlPreviewDefinition {
    let id = "divider"
    let title = "Divider"
    let category = ControlCategory.layout
    let systemImage = "minus"
    let keywords = ["separator", "line", "layout"]

    func makeState() -> DividerPreviewState {
        DividerPreviewState()
    }

    func makePreview(state: Binding<DividerPreviewState>) -> some View {
        if state.wrappedValue.axis == .vertical {
            HStack {
                Text("Leading")
                Divider().background(state.wrappedValue.color.color)
                Text("Trailing")
            }
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 280, height: 80)
        } else {
            VStack {
                Text("Above")
                Divider().background(state.wrappedValue.color.color)
                Text("Below")
            }
            .previewSystemFont(size: state.wrappedValue.fontSize, width: state.wrappedValue.fontWidth)
            .frame(width: 280, height: 120)
        }
    }

    func makeInspector(state: Binding<DividerPreviewState>) -> some View {
        Section("Layout") {
            OptionPicker(title: "Axis", selection: state.axis)
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            OptionPicker(title: "Font Size", selection: state.fontSize)
            OptionPicker(title: "Font Width", selection: state.fontWidth)
        }
    }

    func makeCode(state: DividerPreviewState) -> String {
        let dividerLine = "Divider().background(.\(state.color.codeName))"

        if state.axis == .vertical {
            var lines = [
                "HStack {",
                "    Text(\"Leading\")",
                "    \(dividerLine)",
                "    Text(\"Trailing\")",
                "}"
            ]

            lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
            lines.append(".frame(width: 280, height: 80)")

            return lines.joined(separator: "\n")
        }

        var lines = [
            "VStack {",
            "    Text(\"Above\")",
            "    \(dividerLine)",
            "    Text(\"Below\")",
            "}"
        ]

        lines.append(contentsOf: SwiftUICode.systemFontModifiers(size: state.fontSize, width: state.fontWidth))
        lines.append(".frame(width: 280, height: 120)")

        return lines.joined(separator: "\n")
    }
}

struct DividerPreviewState {
    var axis = PreviewAxisOption.horizontal
    var color = PreviewColorOption.secondary
    var fontSize = PreviewSystemFontSizeOption.body
    var fontWidth = PreviewSystemFontWidthOption.standard
}

struct RectanglePreviewControl: ControlPreviewDefinition {
    let id = "rectangle"
    let title = "Rectangle"
    let category = ControlCategory.graphics
    let systemImage = "rectangle"
    let keywords = ["shape", "drawing", "graphics"]

    func makeState() -> ShapePreviewState {
        ShapePreviewState(width: 180, height: 110, color: .blue)
    }

    func makePreview(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.render(Rectangle(), state: state.wrappedValue)
    }

    func makeInspector(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.inspector(state: state, showsCornerRadius: false)
    }

    func makeCode(state: ShapePreviewState) -> String {
        ShapePreviewSupport.code(shapeExpression: "Rectangle()", state: state)
    }
}

struct RoundedRectanglePreviewControl: ControlPreviewDefinition {
    let id = "rounded-rectangle"
    let title = "RoundedRectangle"
    let category = ControlCategory.graphics
    let systemImage = "rectangle"
    let keywords = ["shape", "corner", "radius", "graphics"]

    func makeState() -> ShapePreviewState {
        ShapePreviewState(width: 180, height: 110, color: .purple, cornerRadius: 24)
    }

    func makePreview(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.render(
            RoundedRectangle(cornerRadius: state.wrappedValue.cornerRadius),
            state: state.wrappedValue
        )
    }

    func makeInspector(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.inspector(state: state, showsCornerRadius: true)
    }

    func makeCode(state: ShapePreviewState) -> String {
        ShapePreviewSupport.code(
            shapeExpression: "RoundedRectangle(cornerRadius: \(SwiftUICode.doubleLiteral(state.cornerRadius)))",
            state: state
        )
    }
}

struct CirclePreviewControl: ControlPreviewDefinition {
    let id = "circle"
    let title = "Circle"
    let category = ControlCategory.graphics
    let systemImage = "circle"
    let keywords = ["shape", "round", "graphics"]

    func makeState() -> ShapePreviewState {
        ShapePreviewState(width: 140, height: 140, color: .green)
    }

    func makePreview(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.render(Circle(), state: state.wrappedValue)
    }

    func makeInspector(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.inspector(state: state, showsCornerRadius: false)
    }

    func makeCode(state: ShapePreviewState) -> String {
        ShapePreviewSupport.code(shapeExpression: "Circle()", state: state)
    }
}

struct EllipsePreviewControl: ControlPreviewDefinition {
    let id = "ellipse"
    let title = "Ellipse"
    let category = ControlCategory.graphics
    let systemImage = "oval"
    let keywords = ["shape", "oval", "graphics"]

    func makeState() -> ShapePreviewState {
        ShapePreviewState(width: 190, height: 110, color: .orange)
    }

    func makePreview(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.render(Ellipse(), state: state.wrappedValue)
    }

    func makeInspector(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.inspector(state: state, showsCornerRadius: false)
    }

    func makeCode(state: ShapePreviewState) -> String {
        ShapePreviewSupport.code(shapeExpression: "Ellipse()", state: state)
    }
}

struct CapsulePreviewControl: ControlPreviewDefinition {
    let id = "capsule"
    let title = "Capsule"
    let category = ControlCategory.graphics
    let systemImage = "capsule"
    let keywords = ["shape", "pill", "graphics"]

    func makeState() -> ShapePreviewState {
        ShapePreviewState(width: 210, height: 86, color: .pink)
    }

    func makePreview(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.render(Capsule(), state: state.wrappedValue)
    }

    func makeInspector(state: Binding<ShapePreviewState>) -> some View {
        ShapePreviewSupport.inspector(state: state, showsCornerRadius: false)
    }

    func makeCode(state: ShapePreviewState) -> String {
        ShapePreviewSupport.code(shapeExpression: "Capsule()", state: state)
    }
}

struct PathPreviewControl: ControlPreviewDefinition {
    let id = "path"
    let title = "Path"
    let category = ControlCategory.graphics
    let systemImage = "point.topleft.down.curvedto.point.bottomright.up"
    let keywords = ["drawing", "bezier", "shape", "graphics"]

    func makeState() -> PathPreviewState {
        PathPreviewState()
    }

    func makePreview(state: Binding<PathPreviewState>) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 20, y: 120))
            path.addCurve(
                to: CGPoint(x: 220, y: 40),
                control1: CGPoint(x: 80, y: 10),
                control2: CGPoint(x: 150, y: 160)
            )
        }
        .stroke(state.wrappedValue.color.color, lineWidth: state.wrappedValue.lineWidth)
        .frame(width: 240, height: 160)
    }

    func makeInspector(state: Binding<PathPreviewState>) -> some View {
        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
            Slider(value: state.lineWidth, in: 1...16, step: 1) {
                Text("Line Width")
            }
        }
    }

    func makeCode(state: PathPreviewState) -> String {
        """
        Path { path in
            path.move(to: CGPoint(x: 20, y: 120))
            path.addCurve(
                to: CGPoint(x: 220, y: 40),
                control1: CGPoint(x: 80, y: 10),
                control2: CGPoint(x: 150, y: 160)
            )
        }
        .stroke(.\(state.color.codeName), lineWidth: \(SwiftUICode.doubleLiteral(state.lineWidth)))
        .frame(width: 240, height: 160)
        """
    }
}

struct PathPreviewState {
    var color = PreviewColorOption.blue
    var lineWidth = 5.0
}

struct CanvasPreviewControl: ControlPreviewDefinition {
    let id = "canvas"
    let title = "Canvas"
    let category = ControlCategory.graphics
    let systemImage = "scribble"
    let keywords = ["drawing", "graphics", "rendering"]

    func makeState() -> CanvasPreviewState {
        CanvasPreviewState()
    }

    func makePreview(state: Binding<CanvasPreviewState>) -> some View {
        Canvas { context, size in
            let rectangle = CGRect(x: 16, y: 16, width: size.width - 32, height: size.height - 32)
            context.fill(Path(ellipseIn: rectangle), with: .color(state.wrappedValue.color.color))
            context.stroke(Path(rectangle), with: .color(.secondary), lineWidth: 2)
        }
        .frame(width: state.wrappedValue.width, height: state.wrappedValue.height)
    }

    func makeInspector(state: Binding<CanvasPreviewState>) -> some View {
        Section("Layout") {
            Slider(value: state.width, in: 120...320, step: 10) {
                Text("Width")
            }
            Slider(value: state.height, in: 100...240, step: 10) {
                Text("Height")
            }
        }

        Section("Style") {
            OptionPicker(title: "Color", selection: state.color)
        }
    }

    func makeCode(state: CanvasPreviewState) -> String {
        """
        Canvas { context, size in
            let rectangle = CGRect(x: 16, y: 16, width: size.width - 32, height: size.height - 32)
            context.fill(Path(ellipseIn: rectangle), with: .color(.\(state.color.codeName)))
            context.stroke(Path(rectangle), with: .color(.secondary), lineWidth: 2)
        }
        .frame(width: \(SwiftUICode.doubleLiteral(state.width)), height: \(SwiftUICode.doubleLiteral(state.height)))
        """
    }
}

struct CanvasPreviewState {
    var width = 220.0
    var height = 160.0
    var color = PreviewColorOption.purple
}

struct ShapePreviewState {
    var width: Double
    var height: Double
    var color: PreviewColorOption
    var rendering = PreviewShapeRenderingOption.fill
    var lineWidth = 4.0
    var cornerRadius = 16.0
}

private enum ShapePreviewSupport {
    @ViewBuilder
    static func render<ShapeType: Shape>(_ shape: ShapeType, state: ShapePreviewState) -> some View {
        switch state.rendering {
        case .fill:
            shape
                .fill(state.color.color)
                .frame(width: state.width, height: state.height)
        case .stroke:
            shape
                .stroke(state.color.color, lineWidth: state.lineWidth)
                .frame(width: state.width, height: state.height)
        }
    }

    @ViewBuilder
    static func inspector(state: Binding<ShapePreviewState>, showsCornerRadius: Bool) -> some View {
        Section("Layout") {
            Slider(value: state.width, in: 60...320, step: 10) {
                Text("Width")
            }
            Slider(value: state.height, in: 60...240, step: 10) {
                Text("Height")
            }

            if showsCornerRadius {
                Slider(value: state.cornerRadius, in: 0...60, step: 2) {
                    Text("Corner Radius")
                }
            }
        }

        Section("Style") {
            OptionPicker(title: "Rendering", selection: state.rendering)
            OptionPicker(title: "Color", selection: state.color)
            Slider(value: state.lineWidth, in: 1...16, step: 1) {
                Text("Line Width")
            }
            .disabled(state.wrappedValue.rendering == .fill)
        }
    }

    static func code(shapeExpression: String, state: ShapePreviewState) -> String {
        var lines = [shapeExpression]

        switch state.rendering {
        case .fill:
            lines.append(".fill(.\(state.color.codeName))")
        case .stroke:
            lines.append(".stroke(.\(state.color.codeName), lineWidth: \(SwiftUICode.doubleLiteral(state.lineWidth)))")
        }

        lines.append(".frame(width: \(SwiftUICode.doubleLiteral(state.width)), height: \(SwiftUICode.doubleLiteral(state.height)))")

        return lines.joined(separator: "\n")
    }
}
