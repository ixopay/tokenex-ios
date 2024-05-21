import SwiftUI
import TokenExMobileAPI

internal struct BINLookupView: View {
    @EnvironmentObject private var settings: Settings

    @State private var pan = ""

    @State private var binResponse: TokenExResult<TXBINLookupResponse> = .uninitialized

    internal var body: some View {
        RequestView("BIN Lookup") {
            RequestSection(
                buttonTitle: "Lookup",
                action: {
                    binResponse = .processing
                    Task {
                        binResponse = await doRequest()
                    }
                },
                content: {
                    CreditCardField(pan: $pan).padding(.bottom)
                }
            )
            .buttonDisabled(binResponse.isProcessing)
            .padding(.bottom)

            TitledSection("Response") {
                BINResponseView(binResponse: $binResponse)
            }
        }
    }

    internal func doRequest() async -> TokenExResult<TXBINLookupResponse> {
        do {
            return .success(
                try await settings.mobileApiClient.binLookup(
                    TXBINLookupRequest(pan: pan)
                )
            )
        } catch {
            return .error(error)
        }
    }
}

internal struct BINResponseView: View {
    @Binding internal var binResponse: TokenExResult<TXBINLookupResponse>

    internal var body: some View {
        switch binResponse {
        case .uninitialized:
            Text("Enter a credit card number to look up.")

        case .processing:
            ProcessingView()

        case .success(let response):
            if response.success {
                BINLookupViewSuccess(bin: response)
            } else {
                BINLookupViewError(bin: response)
            }

        case .error(let error):
            ErrorView(error: error)
        }
    }
}

internal struct BINLookupViewSuccess: View {
    internal let bin: TXBINLookupResponse

    internal var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                LabeledValue(label: "binMin", value: bin.binData?.binMin).padding(.bottom)
                LabeledValue(label: "binMax", value: bin.binData?.binMax).padding(.bottom)
                LabeledValue(label: "binLength", value: bin.binData?.binLength).padding(.bottom)
                LabeledValue(label: "cleanBankName", value: bin.binData?.cleanBankName).padding(.bottom)
                LabeledValue(label: "productName", value: bin.binData?.productName).padding(.bottom)
                LabeledValue(label: "cardBrand", value: bin.binData?.cardBrand).padding(.bottom)
                LabeledValue(label: "countryAlpha2", value: bin.binData?.countryAlpha2).padding(.bottom)
                LabeledValue(label: "countryName", value: bin.binData?.countryName).padding(.bottom)
                LabeledValue(label: "countryNumeric", value: bin.binData?.countryNumeric).padding(.bottom)
                LabeledValue(label: "type", value: bin.binData?.type).padding(.bottom)
                LabeledValue(label: "bankName", value: bin.binData?.bankName).padding(.bottom)
                LabeledValue(label: "bankURL", value: bin.binData?.bankURL).padding(.bottom)
                LabeledValue(label: "bankPhone", value: bin.binData?.bankPhone).padding(.bottom)
                LabeledValue(label: "productCode", value: bin.binData?.productCode).padding(.bottom)
                LabeledValue(label: "prepaid", value: bin.binData?.prepaid).padding(.bottom)
                LabeledValue(label: "regulated", value: bin.binData?.regulated).padding(.bottom)
                LabeledValue(label: "regulatedName", value: bin.binData?.regulatedName).padding(.bottom)
                LabeledValue(label: "reloadable", value: bin.binData?.reloadable).padding(.bottom)
                LabeledValue(label: "panOrToken", value: bin.binData?.panOrToken).padding(.bottom)
                LabeledValue(label: "accountUpdater", value: bin.binData?.accountUpdater).padding(.bottom)
                LabeledValue(label: "alm", value: bin.binData?.alm).padding(.bottom)
                LabeledValue(label: "domesticOnly", value: bin.binData?.domesticOnly).padding(.bottom)
                LabeledValue(label: "gamblingBlocked", value: bin.binData?.gamblingBlocked).padding(.bottom)
                LabeledValue(label: "level2", value: bin.binData?.level2).padding(.bottom)
                LabeledValue(label: "level3", value: bin.binData?.level3).padding(.bottom)
                LabeledValue(label: "issuerCurrency", value: bin.binData?.issuerCurrency).padding(.bottom)
                LabeledValue(label: "cardSegmentType", value: bin.binData?.cardSegmentType).padding(.bottom)
                LabeledValue(label: "comboCard", value: bin.binData?.comboCard).padding(.bottom)
                LabeledValue(label: "cardBrandIsAdditional", value: bin.binData?.cardBrandIsAdditional).padding(.bottom)
                LabeledValue(label: "correlationID", value: bin.binData?.correlationID).padding(.bottom)
                LabeledValue(label: "sharedBin", value: bin.binData?.sharedBin).padding(.bottom)

                ForEach(Array((bin.binData?.cost ?? []).enumerated()), id: \.offset) { index, cost in
                    Text("Cost \(index + 1)").font(.subheadline)
                    VStack(alignment: .leading) {
                        LabeledValue(label: "capTypeName", value: cost.capTypeName)
                        LabeledValue(label: "capFixedAmount", value: cost.capFixedAmount)
                        LabeledValue(label: "capAdvaloremAmount", value: cost.capAdvaloremAmount)
                        LabeledValue(label: "capRegionShortname", value: cost.capRegionShortname)
                        LabeledValue(label: "capTypeQualifierText", value: cost.capTypeQualifierText)
                        LabeledValue(label: "capTypeQualifierLower", value: cost.capTypeQualifierLower)
                        LabeledValue(label: "capTypeQualifierUpper", value: cost.capTypeQualifierUpper)
                        LabeledValue(label: "capTypeQualifierCurrency", value: cost.capTypeQualifierCurrency)
                    }
                    .padding(.leading)
                }.padding(.bottom)

                ForEach(
                    Array((bin.binData?.authentication ?? []).enumerated()),
                    id: \.offset
                ) { index, authentication in
                    Text("Authentication \(index + 1)").font(.subheadline)
                    VStack(alignment: .leading) {
                        LabeledValue(label: "scaName", value: authentication.scaName)
                    }
                    .padding(.leading)
                }.padding(.bottom)

                ForEach(
                    Array((bin.binData?.additionalCardBrands ?? []).enumerated()),
                    id: \.offset
                ) { index, additionalCardBrand in
                    Text("Additional card brand \(index + 1)").font(.subheadline)
                    VStack(alignment: .leading) {
                        LabeledValue(label: "binMin", value: additionalCardBrand.binMin)
                        LabeledValue(label: "binMax", value: additionalCardBrand.binMax)
                        LabeledValue(label: "cardBrand", value: additionalCardBrand.cardBrand)
                        LabeledValue(label: "cardBrandProduct", value: additionalCardBrand.cardBrandProduct)
                        LabeledValue(label: "cardBrandBankName", value: additionalCardBrand.cardBrandBankName)
                        LabeledValue(label: "billPayEnabled", value: additionalCardBrand.billPayEnabled)
                        LabeledValue(label: "ecomEnabled", value: additionalCardBrand.ecomEnabled)
                    }
                    .padding(.leading)
                }.padding(.bottom)

                LabeledValue(label: "Reference number", value: bin.referenceNumber)
            }
        }
    }
}

internal struct BINLookupViewError: View {
    internal let bin: TXBINLookupResponse

    internal var body: some View {
        VStack(alignment: .leading) {
            LabeledValue(label: "Error", value: bin.error).padding(.bottom)
            LabeledValue(label: "Reference number", value: bin.referenceNumber)
        }
    }
}

#Preview {
    BINLookupView().environmentObject(Settings())
}
