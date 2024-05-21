import Nimble
@_spi(TX) @testable import TokenExMobileAPI
import XCTest

internal final class TXMobileAPIClientTests: XCTestCase {
    override internal func setUpWithError() throws {
        TokenExMobileAPIConfiguration.sharedUrlSessionConfiguration.protocolClasses = [MockURLProtocol.self]
    }

    override internal func tearDownWithError() throws {
        MockURLProtocol.urlHandler = .uninitialized
    }

    internal func testTokenizeSuccess() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let token = "1234"
        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { incomingTokenExID, incomingToken in
                expect(incomingTokenExID) == tokenExID
                expect(incomingToken) == token
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            let httpBodyData = try? Data(reading: request.httpBodyStream)
            let httpBody = if let httpBodyData { String(decoding: httpBodyData, as: UTF8.self) } else { nil as String? }

            expect(request.httpMethod) == "POST"
            expect(request.url?.absoluteString) == "https://htp.tokenex.com/api/sdk/Tokenize"
            expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
            expect(request.value(forHTTPHeaderField: "Accept")) == "application/json"

            expect(httpBody).to(contain("\"AuthenticationKey\":\"\(authenticationKey)\""))
            expect(httpBody).to(contain("\"TokenScheme\":\"\(tokenScheme.description)\""))
            expect(httpBody).to(contain("\"Timestamp\":\"\(TXAuthentication.formatDate(timestamp))\""))
            expect(httpBody).to(contain("\"Data\":\"\(data)\""))
            expect(httpBody).to(contain("\"TokenExID\":\"\(tokenExID)\""))

            return (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Success": true,
                        "Token": "\(token)",
                        "TokenHMAC": "\(hmac)",
                        "ReferenceNumber": "\(referenceNumber)"
                    }
                    """.utf8
                )
            )
        }

        let response = try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))

        expect(response.success) == true
        expect(response.error) == nil
        expect(response.token) == token
        expect(response.tokenHMAC) == hmac
        expect(response.referenceNumber) == referenceNumber
    }

    internal func testTokenizeWithCVVSuccess() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let cvv = "456"
        let tokenScheme = TXTokenScheme.PCI

        let token = "1234"
        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { incomingTokenExID, incomingToken in
                expect(incomingTokenExID) == tokenExID
                expect(incomingToken) == token
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            let httpBodyData = try? Data(reading: request.httpBodyStream)
            let httpBody = if let httpBodyData { String(decoding: httpBodyData, as: UTF8.self) } else { nil as String? }

            expect(request.httpMethod) == "POST"
            expect(request.url?.absoluteString) == "https://htp.tokenex.com/api/sdk/TokenizeWithCVV"
            expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
            expect(request.value(forHTTPHeaderField: "Accept")) == "application/json"

            expect(httpBody).to(contain("\"AuthenticationKey\":\"\(authenticationKey)\""))
            expect(httpBody).to(contain("\"TokenScheme\":\"\(tokenScheme.description)\""))
            expect(httpBody).to(contain("\"Timestamp\":\"\(TXAuthentication.formatDate(timestamp))\""))
            expect(httpBody).to(contain("\"Data\":\"\(data)\""))
            expect(httpBody).to(contain("\"CVV\":\"\(cvv)\""))
            expect(httpBody).to(contain("\"TokenExID\":\"\(tokenExID)\""))

            return (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Success": true,
                        "Token": "\(token)",
                        "TokenHMAC": "\(hmac)",
                        "ReferenceNumber": "\(referenceNumber)"
                    }
                    """.utf8
                )
            )
        }

        let response = try await client.tokenizeWithCVV(
            TXTokenizeWithCVVRequest(data: data, tokenScheme: tokenScheme, cvv: cvv)
        )

        expect(response.success) == true
        expect(response.error) == nil
        expect(response.token) == token
        expect(response.tokenHMAC) == hmac
        expect(response.referenceNumber) == referenceNumber
    }

    internal func testTokenizeCVVSuccess() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let token = "1234"
        let cvv = "456"

        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == token
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { incomingTokenExID, incomingToken in
                expect(incomingTokenExID) == tokenExID
                expect(incomingToken) == token
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            let httpBodyData = try? Data(reading: request.httpBodyStream)
            let httpBody = if let httpBodyData { String(decoding: httpBodyData, as: UTF8.self) } else { nil as String? }

            expect(request.httpMethod) == "POST"
            expect(request.url?.absoluteString) == "https://htp.tokenex.com/api/sdk/TokenizeCVV"
            expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
            expect(request.value(forHTTPHeaderField: "Accept")) == "application/json"

            expect(httpBody).to(contain("\"AuthenticationKey\":\"\(authenticationKey)\""))
            expect(httpBody).to(contain("\"Timestamp\":\"\(TXAuthentication.formatDate(timestamp))\""))
            expect(httpBody).to(contain("\"Token\":\"\(token)\""))
            expect(httpBody).to(contain("\"CVV\":\"\(cvv)\""))
            expect(httpBody).to(contain("\"TokenExID\":\"\(tokenExID)\""))

            return (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Success": true,
                        "Token": "\(token)",
                        "TokenHMAC": "\(hmac)",
                        "ReferenceNumber": "\(referenceNumber)"
                    }
                    """.utf8
                )
            )
        }

        let response = try await client.tokenizeCVV(TXTokenizeCVVRequest(token: token, cvv: cvv))

        expect(response.success) == true
        expect(response.error) == nil
        expect(response.token) == token
        expect(response.tokenHMAC) == hmac
        expect(response.referenceNumber) == referenceNumber
    }

    internal func testBINLookupSuccess() async throws {  // swiftlint:disable:this function_body_length
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let pan = "1234"
        let tokenScheme = TXTokenScheme.PCI

        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { _, _ in
                fail("unexpected call to token HMAC provider")
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            let httpBodyData = try? Data(reading: request.httpBodyStream)
            let httpBody = if let httpBodyData { String(decoding: httpBodyData, as: UTF8.self) } else { nil as String? }

            expect(request.httpMethod) == "POST"
            expect(request.url?.absoluteString) == "https://htp.tokenex.com/api/sdk/BinLookup"
            expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
            expect(request.value(forHTTPHeaderField: "Accept")) == "application/json"

            expect(httpBody).to(contain("\"AuthenticationKey\":\"\(authenticationKey)\""))
            expect(httpBody).to(contain("\"Timestamp\":\"\(TXAuthentication.formatDate(timestamp))\""))
            expect(httpBody).to(contain("\"Pan\":\"\(pan)\""))
            expect(httpBody).to(contain("\"TokenScheme\":\"\(tokenScheme)\""))
            expect(httpBody).to(contain("\"TokenExID\":\"\(tokenExID)\""))

            return (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Error": null,
                        "Success": true,
                        "ReferenceNumber": "\(referenceNumber)",
                        "BinData": {
                            "BinMin": "4978873300000000000",
                            "BinMax": "4978873399999999999",
                            "BinLength": 8,
                            "CleanBankName": "",
                            "ProductName": "Visa Gold",
                            "CardBrand": "VISA",
                            "CountryAlpha2": "FR",
                            "CountryName": "FRANCE",
                            "CountryNumeric": "250",
                            "Type": "Debit",
                            "BankName": "BPCE",
                            "BankUrl": "",
                            "BankPhone": "",
                            "ProductCode": "P",
                            "Prepaid": false,
                            "Regulated": null,
                            "RegulatedName": "",
                            "Reloadable": false,
                            "PanOrToken": "pan",
                            "AccountUpdater": true,
                            "Alm": false,
                            "DomesticOnly": false,
                            "GamblingBlocked": true,
                            "Level2": false,
                            "Level3": false,
                            "IssuerCurrency": "EUR",
                            "CardSegmentType": "Consumer",
                            "ComboCard": "",
                            "CardBrandIsAdditional": false,
                            "CorrelationId": "eyJGaWxlSWQiOjEwNjg4LCJWZXJzaW9uIjo1NH0=",
                            "SharedBin": false,
                            "Cost": [
                                {
                                    "CapFixedAmount": 0.0,
                                    "CapAdvaloremAmount": 0.002,
                                    "CapTypeQualifierText": "EU MIF"
                                },
                                {
                                    "CapFixedAmount": 0.0,
                                    "CapAdvaloremAmount": 0.0115,
                                    "CapTypeQualifierText": "EU XB CNP MIF"
                                }
                            ],
                            "Authentication": [
                                {
                                    "SCAName": "EU PSD2 - SCA"
                                }
                            ],
                            "AdditionalCardBrands": [
                                {
                                    "BinMin": "4978870000000000000",
                                    "BinMax": "4978879999999999999",
                                    "CardBrand": "CARTE BANCAIRE",
                                    "CardBrandProduct": "",
                                    "CardBrandBankName": "LOIRE CENTRE",
                                    "BillpayEnabled": null,
                                    "EcomEnabled": null
                                }
                            ]
                        }
                    }
                    """.utf8
                )
            )
        }

        let response = try await client.binLookup(TXBINLookupRequest(pan: pan))

        expect(response.success) == true
        expect(response.error) == nil
        expect(response.referenceNumber) == referenceNumber

        guard let binData = response.binData else {
            fail("Expected BIN data to be present.")
            return
        }

        // swiftlint:disable legacy_objc_type
        expect(binData.binMin) == "4978873300000000000"
        expect(binData.binMax) == "4978873399999999999"
        expect(binData.binLength) == 8
        expect(binData.binLengthBridged) == NSNumber(value: 8)
        expect(binData.cleanBankName).to(beEmpty())
        expect(binData.productName) == "Visa Gold"
        expect(binData.cardBrand) == "VISA"
        expect(binData.countryAlpha2) == "FR"
        expect(binData.countryName) == "FRANCE"
        expect(binData.countryNumeric) == "250"
        expect(binData.type) == "Debit"
        expect(binData.bankName) == "BPCE"
        expect(binData.bankURL).to(beEmpty())
        expect(binData.bankPhone).to(beEmpty())
        expect(binData.productCode) == "P"
        expect(binData.prepaid) == false
        expect(binData.prepaidBridged) == NSNumber(value: 0)
        expect(binData.regulated) == nil
        expect(binData.regulatedName).to(beEmpty())
        expect(binData.reloadable) == false
        expect(binData.reloadableBridged) == NSNumber(value: 0)
        expect(binData.panOrToken) == "pan"
        expect(binData.accountUpdater) == true
        expect(binData.accountUpdaterBridged) == NSNumber(value: 1)
        expect(binData.alm) == false
        expect(binData.almBridged) == NSNumber(value: 0)
        expect(binData.domesticOnly) == false
        expect(binData.domesticOnlyBridged) == NSNumber(value: 0)
        expect(binData.gamblingBlocked) == true
        expect(binData.gamblingBlockedBridged) == NSNumber(value: 1)
        expect(binData.level2) == false
        expect(binData.level2Bridged) == NSNumber(value: 0)
        expect(binData.level3) == false
        expect(binData.level3Bridged) == NSNumber(value: 0)
        expect(binData.issuerCurrency) == "EUR"
        expect(binData.cardSegmentType) == "Consumer"
        expect(binData.comboCard).to(beEmpty())
        expect(binData.cardBrandIsAdditional) == false
        expect(binData.cardBrandIsAdditionalBridged) == NSNumber(value: 0)
        expect(binData.correlationID) == "eyJGaWxlSWQiOjEwNjg4LCJWZXJzaW9uIjo1NH0="
        expect(binData.sharedBin) == false
        expect(binData.sharedBinBridged) == NSNumber(value: 0)
        expect(binData.cost).to(haveCount(2))
        expect(binData.cost[0].capFixedAmount) == 0.0
        expect(binData.cost[0].capAdvaloremAmount) == 0.002
        expect(binData.cost[0].capAdvaloremAmountBridged) == NSDecimalNumber(decimal: 0.002)
        expect(binData.cost[0].capTypeQualifierText) == "EU MIF"
        expect(binData.cost[1].capFixedAmount) == 0.0
        expect(binData.cost[1].capAdvaloremAmount) == 0.0115
        expect(binData.cost[1].capAdvaloremAmountBridged) == NSDecimalNumber(decimal: 0.0115)
        expect(binData.cost[1].capTypeQualifierText) == "EU XB CNP MIF"
        expect(binData.authentication).to(haveCount(1))
        expect(binData.authentication[0].scaName) == "EU PSD2 - SCA"
        expect(binData.additionalCardBrands).to(haveCount(1))
        expect(binData.additionalCardBrands[0].binMin) == "4978870000000000000"
        expect(binData.additionalCardBrands[0].binMax) == "4978879999999999999"
        expect(binData.additionalCardBrands[0].cardBrand) == "CARTE BANCAIRE"
        expect(binData.additionalCardBrands[0].cardBrandProduct).to(beEmpty())
        expect(binData.additionalCardBrands[0].cardBrandBankName) == "LOIRE CENTRE"
        expect(binData.additionalCardBrands[0].billPayEnabled) == nil
        expect(binData.additionalCardBrands[0].ecomEnabled) == nil
        // swiftlint:enable legacy_objc_type
    }

    internal func testConfigurationError() async throws {
        await expect {
            try await TXMobileAPIClient.shared.tokenize(
                TXTokenizeRequest(data: "1234", tokenScheme: TXTokenScheme.PCI)
            )
        }.to(
            throwError { (error: NSError) in
                expect(error).to(
                    matchError(
                        NSError(
                            domain: TXError.tokenExDomain,
                            code: TXErrorCode.configurationErrorNoTokenExId.rawValue
                        )
                    )
                )
            }
        )

        TokenExMobileAPISettings.defaultTokenExID = "default-tokenex-id"

        await expect {
            try await TXMobileAPIClient.shared.tokenize(
                TXTokenizeRequest(data: "1234", tokenScheme: TXTokenScheme.PCI)
            )
        }.to(
            throwError { (error: NSError) in
                expect(error).to(
                    matchError(
                        NSError(
                            domain: TXError.tokenExDomain,
                            code: TXErrorCode.configurationErrorNoAuthenticationProvider.rawValue
                        )
                    )
                )
            }
        )
    }

    internal func testErrorResponse() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { _, _ in
                fail("expected no hmac request if initial call fails")
            }
        )

        let error = URLError(URLError.notConnectedToInternet)

        MockURLProtocol.urlHandler = .error(error)

        await expect {
            try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))
        }.to(
            throwError { error in
                expect(error).to(matchError(error))
            }
        )
    }

    internal func testInvalidDataResponse() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { _, _ in
                fail("expected no hmac request if initial call fails")
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data("This is not valid JSON!".utf8)
            )
        }

        await expect {
            try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))
        }.to(
            throwError { (error: NSError) in
                expect(error.domain) == TXError.tokenExDomain
                expect(error.code) == TXErrorCode.apiError.rawValue
            }
        )
    }

    internal func testErrorAuthenticationKey() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { _, _ in
                throw NSError(domain: "test", code: 123)
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { _, _ in
                fail("expected no hmac request if initial call fails")
            }
        )

        MockURLProtocol.urlHandler = .request { _ in
            fail("expect url handler not to be called since authentication key calculation alreday fails")
            throw NSError(domain: "test", code: 0)
        }

        await expect {
            try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))
        }.to(
            throwError { error in
                expect(error).to(
                    matchError(
                        NSError(
                            domain: TXError.tokenExDomain,
                            code: TXErrorCode.authenticationProviderError.rawValue,
                            userInfo: [
                                NSUnderlyingErrorKey: NSError(domain: "test", code: 123)
                            ]
                        )
                    )
                )
            }
        )
    }

    internal func testErrorTokenHMACProvider() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let token = "1234"
        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { _, _ in
                throw NSError(domain: "test", code: 123)
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Success": true,
                        "Token": "\(token)",
                        "TokenHMAC": "\(hmac)",
                        "ReferenceNumber": "\(referenceNumber)"
                    }
                    """.utf8
                )
            )
        }

        await expect {
            try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))
        }.to(
            throwError { error in
                expect(error).to(
                    matchError(
                        NSError(
                            domain: TXError.tokenExDomain,
                            code: TXErrorCode.tokenHMACProviderError.rawValue,
                            userInfo: [
                                NSUnderlyingErrorKey: NSError(domain: "test", code: 123)
                            ]
                        )
                    )
                )
            }
        )
    }

    internal func testTokenHMACMismatch() async throws {
        let tokenExID = "test-tokenex-id"
        let authenticationKey = "constant-authentication-key"
        let hmac = "constant-hmac"

        let timestamp = Date()
        let data = "the-data"
        let tokenScheme = TXTokenScheme.PCI

        let token = "1234"
        let referenceNumber = "constant-reference-number"

        let client = TXMobileAPIClient(
            tokenExID: tokenExID,
            authenticationKeyProvider: ConstantAuthenticationKeyProvider(
                key: authenticationKey,
                timestamp: timestamp
            ) { incomingTokenExID, incomingTokenOrTokenScheme in
                expect(incomingTokenExID) == tokenExID
                expect(incomingTokenOrTokenScheme) == tokenScheme.description
            },
            tokenHMACProvider: ConstantTokenHMACProvider(hmac: hmac) { incomingTokenExID, incomingToken in
                expect(incomingTokenExID) == tokenExID
                expect(incomingToken) == token
            }
        )

        MockURLProtocol.urlHandler = .request { request in
            (
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "1.1",
                    headerFields: ["Content-Type": "application/json"]
                )!,
                Data(
                    """
                    {
                        "Success": true,
                        "Token": "\(token)",
                        "TokenHMAC": "\(hmac)-but-different",
                        "ReferenceNumber": "\(referenceNumber)"
                    }
                    """.utf8
                )
            )
        }

        await expect {
            try await client.tokenize(TXTokenizeRequest(data: data, tokenScheme: tokenScheme))
        }.to(
            throwError { error in
                expect(error).to(
                    matchError(
                        NSError(
                            domain: TXError.tokenExDomain,
                            code: TXErrorCode.tokenHMACMismatchError.rawValue
                        )
                    )
                )
            }
        )
    }

    deinit {}
}
