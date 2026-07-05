import SwiftUI

protocol PreviewOption: CaseIterable, Hashable, Identifiable {
    var title: String { get }
}

extension PreviewOption {
    var id: Self { self }
}

struct OptionPicker<Option: PreviewOption>: View {
    let title: String
    @Binding var selection: Option

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                Text(option.title).tag(option)
            }
        }
    }
}

enum PreviewControlSizeOption: String, PreviewOption {
    case mini
    case small
    case regular
    case large

    var title: String {
        switch self {
        case .mini:
            "Mini"
        case .small:
            "Small"
        case .regular:
            "Regular"
        case .large:
            "Large"
        }
    }

    var controlSize: ControlSize {
        switch self {
        case .mini:
            .mini
        case .small:
            .small
        case .regular:
            .regular
        case .large:
            .large
        }
    }
}

enum PreviewColorOption: String, PreviewOption {
    case primary
    case secondary
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case gray
    case black
    case white

    var title: String {
        switch self {
        case .primary:
            "Primary"
        case .secondary:
            "Secondary"
        case .red:
            "Red"
        case .orange:
            "Orange"
        case .yellow:
            "Yellow"
        case .green:
            "Green"
        case .mint:
            "Mint"
        case .teal:
            "Teal"
        case .cyan:
            "Cyan"
        case .blue:
            "Blue"
        case .indigo:
            "Indigo"
        case .purple:
            "Purple"
        case .pink:
            "Pink"
        case .brown:
            "Brown"
        case .gray:
            "Gray"
        case .black:
            "Black"
        case .white:
            "White"
        }
    }

    var color: Color {
        switch self {
        case .primary:
            .primary
        case .secondary:
            .secondary
        case .red:
            .red
        case .orange:
            .orange
        case .yellow:
            .yellow
        case .green:
            .green
        case .mint:
            .mint
        case .teal:
            .teal
        case .cyan:
            .cyan
        case .blue:
            .blue
        case .indigo:
            .indigo
        case .purple:
            .purple
        case .pink:
            .pink
        case .brown:
            .brown
        case .gray:
            .gray
        case .black:
            .black
        case .white:
            .white
        }
    }

    var codeName: String {
        rawValue
    }
}

enum PreviewSystemFontSizeOption: String, PreviewOption {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case callout
    case footnote
    case caption
    case caption2

    var title: String {
        switch self {
        case .largeTitle:
            "Large Title"
        case .title:
            "Title"
        case .title2:
            "Title 2"
        case .title3:
            "Title 3"
        case .headline:
            "Headline"
        case .subheadline:
            "Subheadline"
        case .body:
            "Body"
        case .callout:
            "Callout"
        case .footnote:
            "Footnote"
        case .caption:
            "Caption"
        case .caption2:
            "Caption 2"
        }
    }

    var font: Font {
        .system(textStyle)
    }

    var textStyle: Font.TextStyle {
        switch self {
        case .largeTitle:
            .largeTitle
        case .title:
            .title
        case .title2:
            .title2
        case .title3:
            .title3
        case .headline:
            .headline
        case .subheadline:
            .subheadline
        case .body:
            .body
        case .callout:
            .callout
        case .footnote:
            .footnote
        case .caption:
            .caption
        case .caption2:
            .caption2
        }
    }

    var code: String {
        ".\(rawValue)"
    }
}

enum PreviewSystemFontWidthOption: String, PreviewOption {
    case compressed
    case condensed
    case standard
    case expanded

    var title: String {
        switch self {
        case .compressed:
            "Compressed"
        case .condensed:
            "Condensed"
        case .standard:
            "Standard"
        case .expanded:
            "Expanded"
        }
    }

    var width: Font.Width {
        switch self {
        case .compressed:
            .compressed
        case .condensed:
            .condensed
        case .standard:
            .standard
        case .expanded:
            .expanded
        }
    }

    var code: String {
        ".\(rawValue)"
    }
}

extension SwiftUICode {
    static func systemFontModifiers(
        size: PreviewSystemFontSizeOption,
        width: PreviewSystemFontWidthOption
    ) -> [String] {
        var lines: [String] = []

        if size != .body {
            lines.append(".font(.system(\(size.code)))")
        }

        if width != .standard {
            lines.append(".fontWidth(\(width.code))")
        }

        return lines
    }
}

extension View {
    func previewSystemFont(
        size: PreviewSystemFontSizeOption,
        width: PreviewSystemFontWidthOption
    ) -> some View {
        font(size.font)
            .fontWidth(width.width)
    }
}

enum PreviewAxisOption: String, PreviewOption {
    case vertical
    case horizontal

    var title: String {
        switch self {
        case .vertical:
            "Vertical"
        case .horizontal:
            "Horizontal"
        }
    }

    var axes: Axis.Set {
        switch self {
        case .vertical:
            .vertical
        case .horizontal:
            .horizontal
        }
    }
}

enum PreviewShapeRenderingOption: String, PreviewOption {
    case fill
    case stroke

    var title: String {
        switch self {
        case .fill:
            "Fill"
        case .stroke:
            "Stroke"
        }
    }
}
