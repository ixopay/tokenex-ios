import SwiftUI

internal struct RequestSection<Content: View>: View {
    internal var buttonTitle: String
    internal var action: () -> Void
    internal let content: Content

    @State private var buttonDisabled = false

    internal var body: some View {
        TitledSection("Request") {
            content

            Button(buttonTitle) {
                UIApplication.shared.endEditing()
                action()
            }
            .disabled(buttonDisabled)
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
    }

    @inlinable
    internal init(buttonTitle: String, action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.buttonTitle = buttonTitle
        self.action = action
        self.content = content()
    }

    @inlinable
    internal func buttonDisabled(_ disabled: Bool) -> some View {
        buttonDisabled = disabled
        return body
    }
}

#Preview {
    RequestSection(buttonTitle: "Action", action: {}, content: {})
}
