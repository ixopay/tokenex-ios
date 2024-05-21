import Nimble
@_spi(TX) @testable import TokenExMobileAPI
import XCTest

internal final class TXBINLookupResponseTests: XCTestCase {
    private let decoder = TXMobileAPIClient.decoder

    internal func testDecodeUnknown() throws {
        let obj = try decoder.decode(
            TXBINLookupResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "BinData": {},
                    "UNKNOWN_PROPRTY": "UNKNOWN_VALUE"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.binData) != nil
    }

    internal func testDecodeMissingError() throws {
        let obj = try decoder.decode(
            TXBINLookupResponse.self,
            from: Data(
                """
                {
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber",
                    "BinData": {},
                }
                """.utf8
            )
        )

        expect(obj.error) == nil
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.binData) != nil
    }

    internal func testDecodeMissingSuccess() throws {
        let options = XCTExpectedFailure.Options()
        options.isStrict = false

        expect {
            try self.decoder.decode(
                TXBINLookupResponse.self,
                from: Data(
                    """
                    {
                        "Error": "val-Error",
                        "ReferenceNumber": "val-ReferenceNumber",
                        "BinData": {},
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
            TXBINLookupResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "BinData": {},
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == nil
        expect(obj.binData) != nil
    }

    internal func testDecodeMissingBinData() throws {
        let obj = try decoder.decode(
            TXBINLookupResponse.self,
            from: Data(
                """
                {
                    "Error": "val-Error",
                    "Success": true,
                    "ReferenceNumber": "val-ReferenceNumber"
                }
                """.utf8
            )
        )

        expect(obj.error) == "val-Error"
        expect(obj.success) == true
        expect(obj.referenceNumber) == "val-ReferenceNumber"
        expect(obj.binData) == nil
    }

    deinit {}
}
