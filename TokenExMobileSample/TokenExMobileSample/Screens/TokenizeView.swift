import SwiftUI
import TokenExMobileAPI

internal struct TokenizeView: View {
    @EnvironmentObject private var settings: Settings

    @State private var pan = ""
    @State private var tokenScheme = TXTokenScheme.sixTOKENfour
    @State private var useExtendedBIN = false

    @State private var tokenResponse: TokenExResult<TXTokenResponse> = .uninitialized

    internal var body: some View {
        RequestView("Tokenize") {
            RequestSection(
                buttonTitle: "Tokenize",
                action: {
                    tokenResponse = .processing
                    Task {
                        tokenResponse = await doRequest()
                    }
                },
                content: {
                    CreditCardField(pan: $pan).padding(.bottom)
                    TokenSchemePicker(tokenScheme: $tokenScheme)
                    UseExtendedBINField(useExtendedBIN: $useExtendedBIN).padding(.bottom)
                }
            )
            .buttonDisabled(tokenResponse.isProcessing)
            .padding(.bottom)

            TitledSection("Response") {
                TokenizeResponseView(
                    uninitializedText: "Enter a credit card number to tokenize.",
                    tokenResponse: $tokenResponse
                )
            }
        }
    }

    internal func doRequest() async -> TokenExResult<TXTokenResponse> {
        do {
            return .success(
                try await settings.mobileApiClient.tokenize(
                    TXTokenizeRequest(
                        data: pan,
                        tokenScheme: tokenScheme,
                        useExtendedBIN: useExtendedBIN
                    )
                )
            )
        } catch {
            return .error(error)
        }
    }
}

#Preview {
    TokenizeView().environmentObject(Settings())
}
