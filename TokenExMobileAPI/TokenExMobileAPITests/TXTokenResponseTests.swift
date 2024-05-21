import Nimble
@testable import TokenExMobileAPI
import XCTest

internal final class TXTokenResponseTests: XCTestCase {
    private let decoder = JSONDecoder()

    internal func testDecodeUnknown() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "Token": "val-Token",
                    "TokenHMAC": "val-TokenHMAC",
                    "FirstEight": "val-FirstEight",
                    "UNKNOWN_PROPRTY": "UNKNOWN_VALUE"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.token) == "val-Token"
        expect(obj.tokenHMAC) == "val-TokenHMAC"
        expect(obj.firstEight) == "val-FirstEight"
    }

    internal func testDecodeMissingError() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "Token": "val-Token",
                    "TokenHMAC": "val-TokenHMAC",
                    "FirstEight": "val-FirstEight"
                }
                """.utf8
            )
        )

        expect(obj.error) == nil
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.token) == "val-Token"
        expect(obj.tokenHMAC) == "val-TokenHMAC"
        expect(obj.firstEight) == "val-FirstEight"
    }

    internal func testDecodeMissingSuccess() throws {
        let options = XCTExpectedFailure.Options()
        options.isStrict = false

        expect {
            try self.decoder.decode(
                TXTokenResponse.self,
                from: Data(
                    """
                    {
                        "Error": "val-Error",
                        "ReferenceNumber": "val-ReferenceNumber",
                        "Token": "val-Token",
                        "TokenHMAC": "val-TokenHMAC",
                        "FirstEight": "val-FirstEight"
                    }
                    """.utf8
                )
            )
        }.to(
            throwError { error in
                guard case let DecodingError.keyNotFound(key, _) = error else {
                    fail("expected key not found error")
                    return
                }
                expect(key.stringValue) == "Success"
            }
        )
    }

    internal func testDecodeMissingReferenceNumber() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "Token": "val-Token",
                    "TokenHMAC": "val-TokenHMAC",
                    "FirstEight": "val-FirstEight"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == nil
        expect(obj.token) == "val-Token"
        expect(obj.tokenHMAC) == "val-TokenHMAC"
        expect(obj.firstEight) == "val-FirstEight"
    }

    internal func testDecodeMissingToken() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "TokenHMAC": "val-TokenHMAC",
                    "FirstEight": "val-FirstEight"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.token) == nil
        expect(obj.tokenHMAC) == "val-TokenHMAC"
        expect(obj.firstEight) == "val-FirstEight"
    }

    internal func testDecodeMissingTokenHMAC() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "Token": "val-Token",
                    "FirstEight": "val-FirstEight"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.token) == "val-Token"
        expect(obj.tokenHMAC) == nil
        expect(obj.firstEight) == "val-FirstEight"
    }

    internal func testDecodeMissingFirstEight() throws {
        let obj = try decoder.decode(
            TXTokenResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "Token": "val-Token",
                    "TokenHMAC": "val-TokenHMAC"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.token) == "val-Token"
        expect(obj.tokenHMAC) == "val-TokenHMAC"
        expect(obj.firstEight) == nil
    }

    deinit {}
}
