import SwiftUI

internal struct LabeledValue<T: CustomStringConvertible>: View {
    internal let label: String
    internal let value: T?

    internal var body: some View {
        LabeledContent(label) {
            if let value {
                if value.description.isEmpty {
                    Text("empty").foregroundStyle(.gray)
                } else {
                    Text(value.description)
                        .textSelection(.enabled)
                        .contextMenu(
                            ContextMenu {
                                Button("Copy") {
                                    UIPasteboard.general.string = value.description
                                }
                            }
                        )
                }
            } else {
                Text("nil").foregroundStyle(.gray)
            }
        }
    }
}
