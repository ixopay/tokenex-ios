import Foundation

@objc
public class TXTokenResponse: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case error = "Error"
        case success = "Success"
        case referenceNumber = "ReferenceNumber"
        case token = "Token"
        case tokenHMAC = "TokenHMAC"
        case firstEight = "FirstEight"
    }

    @objc public private(set) var error: String?
    @objc public private(set) var success = false
    @objc public private(set) var referenceNumber: String?

    @objc public private(set) var token: String?
    @objc public private(set) var tokenHMAC: String?
    @objc public private(set) var firstEight: String?

    override public var debugDescription: String {
        if success {
            // swiftlint:disable:next line_length
            "<TXTokenResponse: token=\(token ?? "nil") tokenHMAC=\(tokenHMAC ?? "nil") firstEight=\(firstEight ?? "nil") referenceNumber=\(referenceNumber ?? "nil")>"
        } else {
            "<TXTokenResponse: error=\(error ?? "nil") referenceNumber=\(referenceNumber ?? "nil")>"
        }
    }

    deinit {}
}
