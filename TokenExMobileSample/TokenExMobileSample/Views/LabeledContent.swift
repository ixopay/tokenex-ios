import SwiftUI

internal struct LabeledContent<Content: View>: View {
    internal let label: String
    internal let content: Content

    internal var body: some View {
        VStack(alignment: .leading) {
            Text(label).foregroundStyle(.secondary).font(.caption)
            content
        }
    }

    @inlinable
    internal init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content()
    }

    @inlinable
    internal init<S>(_ label: S, @ViewBuilder content: @escaping () -> Content) where S: StringProtocol {
        self.label = String(label)
        self.content = content()
    }
}
