import SwiftUI
import TokenExMobileAPI

internal struct ErrorView: View {
    internal let error: Error

    internal var body: some View {
        VStack(alignment: .leading) {
            LabeledValue(label: "Error", value: error.localizedDescription)
        }
    }
}

#Preview {
    ErrorView(error: NSError(domain: TXError.tokenExDomain, code: 0))
}
