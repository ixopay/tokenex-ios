import SwiftUI
import TokenExMobileAPI

internal struct TokenizeWithCVVView: View {
    @EnvironmentObject private var settings: Settings

    @State private var pan = ""
    @State private var cvv = ""
    @State private var tokenScheme = TXTokenScheme.sixTOKENfour
    @State private var useExtendedBIN = false

    @State private var tokenResponse: TokenExResult<TXTokenResponse> = .uninitialized

    internal var body: some View {
        RequestView("Tokenize with CVV") {
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
                    CVVField(cvv: $cvv).padding(.bottom)
                    TokenSchemePicker(tokenScheme: $tokenScheme)
                    UseExtendedBINField(useExtendedBIN: $useExtendedBIN).padding(.bottom)
                }
            )
            .buttonDisabled(tokenResponse.isProcessing)
            .padding(.bottom)

            TitledSection("Response") {
                TokenizeResponseView(
                    uninitializedText: "Enter a credit card number and CVV to tokenize.",
                    tokenResponse: $tokenResponse
                )
            }
        }
    }

    internal func doRequest() async -> TokenExResult<TXTokenResponse> {
        do {
            return .success(
                try await settings.mobileApiClient.tokenizeWithCVV(
                    TXTokenizeWithCVVRequest(
                        data: pan,
                        tokenScheme: tokenScheme,
                        cvv: cvv,
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
    TokenizeWithCVVView().environmentObject(Settings())
}
