import SwiftUI
import TokenExMobileAPI

internal struct TokenizeCVVView: View {
    @EnvironmentObject private var settings: Settings

    @State private var token = ""
    @State private var cvv = ""

    @State private var tokenResponse: TokenExResult<TXTokenResponse> = .uninitialized

    internal var body: some View {
        RequestView("Tokenize CVV") {
            RequestSection(
                buttonTitle: "Associate CVV",
                action: {
                    tokenResponse = .processing
                    Task {
                        tokenResponse = await doRequest()
                    }
                },
                content: {
                    LabeledContent("Token ID") {
                        TextField("1234567890", text: $token)
                            .keyboardType(.decimalPad)
                    }.padding(.bottom)

                    CVVField(cvv: $cvv).padding(.bottom)
                }
            )
            .buttonDisabled(tokenResponse.isProcessing)
            .padding(.bottom)

            TitledSection("Response") {
                TokenizeResponseView(
                    uninitializedText: "Enter a token ID and CVV to tokenize.",
                    tokenResponse: $tokenResponse
                )
            }
        }
    }

    internal func doRequest() async -> TokenExResult<TXTokenResponse> {
        do {
            return .success(
                try await settings.mobileApiClient.tokenizeCVV(
                    TXTokenizeCVVRequest(token: token, cvv: cvv)
                )
            )
        } catch {
            return .error(error)
        }
    }
}

#Preview {
    TokenizeCVVView().environmentObject(Settings())
}
