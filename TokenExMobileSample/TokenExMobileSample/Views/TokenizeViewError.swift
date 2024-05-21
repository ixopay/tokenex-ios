import SwiftUI
import TokenExMobileAPI

internal struct TokenizeViewError: View {
    internal let token: TXTokenResponse

    internal var body: some View {
        VStack(alignment: .leading) {
            LabeledValue(label: "Error", value: token.error).padding(.bottom)
            LabeledValue(label: "Reference number", value: token.referenceNumber)
        }
    }
}

#Preview {
    TokenizeViewError(token: TXTokenResponse())
}
