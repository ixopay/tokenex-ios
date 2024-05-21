import SwiftUI

internal struct TitledSection<Content: View>: View {
    internal let title: String
    internal let content: Content

    internal var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).padding(.bottom)

            content
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity /*@END_MENU_TOKEN@*/, alignment: .leading)
    }

    @inlinable
    internal init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }

    @inlinable
    internal init<S>(_ title: S, @ViewBuilder content: @escaping () -> Content) where S: StringProtocol {
        self.title = String(title)
        self.content = content()
    }
}
