import SwiftUI
#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct ControlDetailView: View {
    let control: AnyControlPreview
    @Binding var state: Any

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                PreviewSurface {
                    control.makePreview(state: $state)
                }

                GeneratedCodeView(code: control.makeCode(state: state))
            }
            .padding(24)
            .frame(maxWidth: 920, alignment: .leading)
        }
        .background(.background)
    }
}

private struct PreviewSurface<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack {
            content
        }
        .frame(maxWidth: .infinity, minHeight: 280)
        .padding(32)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

private struct GeneratedCodeView: View {
    let code: String
    @AppStorage("SwiftUIPreview.showsCodeLineNumbers") private var showsLineNumbers = false
    @State private var isExpanded = true
    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Button {
                    withAnimation(.snappy(duration: 0.18)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                }
                .buttonStyle(.plain)
                .help(isExpanded ? "Collapse Code" : "Expand Code")

                Text("Code")
                    .font(.headline)

                Spacer()

                Button {
                    showsLineNumbers.toggle()
                } label: {
                    Image(systemName: "list.number")
                }
                .buttonStyle(.borderless)
                .help(showsLineNumbers ? "Hide Line Numbers" : "Show Line Numbers")

                Button {
                    CodeClipboard.copy(code)
                    didCopy = true
                } label: {
                    Label(didCopy ? "Copied" : "Copy", systemImage: didCopy ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.bordered)
                .help("Copy Code")
                .onChange(of: code) { _, _ in
                    didCopy = false
                }
            }

            if isExpanded {
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 12) {
                        if showsLineNumbers {
                            Text(SwiftUICode.lineNumberText(for: code))
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.trailing)
                                .textSelection(.disabled)

                            Rectangle()
                                .fill(.quaternary)
                                .frame(width: 1)
                        }

                        Text(SwiftCodeHighlighter.highlighted(code))
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(14)
                    .fixedSize(horizontal: true, vertical: false)
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.quaternary)
                }
            }
        }
    }
}

private enum CodeClipboard {
    static func copy(_ string: String) {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
        #elseif canImport(UIKit)
        UIPasteboard.general.string = string
        #endif
    }
}
