import SwiftUI
import TokenExMobileAPI

internal struct TokenizeResponseView: View {
    internal var uninitializedText: String
    @Binding internal var tokenResponse: TokenExResult<TXTokenResponse>

    internal var body: some View {
        switch tokenResponse {
        case .uninitialized:
            Text(uninitializedText)

        case .processing:
            ProcessingView()

        case .success(let response):
            if response.success {
                TokenizeViewSuccess(token: response)
            } else {
                TokenizeViewError(token: response)
            }

        case .error(let error):
            ErrorView(error: error)
        }
    }
}

#Preview {
    TokenizeResponseView(uninitializedText: "Uninitialized", tokenResponse: .constant(.uninitialized))
}
