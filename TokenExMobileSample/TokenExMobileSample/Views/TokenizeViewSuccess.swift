import SwiftUI
import TokenExMobileAPI

internal struct TokenizeViewSuccess: View {
    internal let token: TXTokenResponse

    internal var body: some View {
        VStack(alignment: .leading) {
            LabeledValue(label: "Token", value: token.token).padding(.bottom)
            LabeledValue(label: "Token HMAC", value: token.tokenHMAC).padding(.bottom)
            LabeledValue(label: "First eight", value: token.firstEight).padding(.bottom)
            LabeledValue(label: "Reference number", value: token.referenceNumber)
        }
    }
}

#Preview {
    TokenizeViewSuccess(token: TXTokenResponse())
}
