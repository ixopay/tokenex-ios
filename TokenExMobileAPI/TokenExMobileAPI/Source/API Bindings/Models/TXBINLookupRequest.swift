import Foundation

/// Lookup information an account number in the bank identification number (BIN) database.
@objc
public class TXBINLookupRequest: NSObject, Encodable {
    private enum CodingKeys: String, CodingKey {
        case tokenExID = "TokenExID"
        case timestamp = "Timestamp"
        case authenticationKey = "AuthenticationKey"

        case pan = "Pan"
        case tokenScheme = "TokenScheme"
    }

    internal var authentication: TXAuthenticatedRequest?

    /// The PAN to lookup in BIN database
    @objc public let pan: String

    /// The Token Scheme to be used to tokenize the provided data. Not exposed since it's unused.
    internal let tokenScheme = TXTokenScheme.PCI

    @objc(initWithPan:)
    public init(pan: String) {
        self.pan = pan
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        guard let authentication else {
            throw TokenExError.internalError()
        }

        try container.encode(authentication.tokenExID, forKey: .tokenExID)
        try container.encode(authentication.timestamp, forKey: .timestamp)
        try container.encode(authentication.authenticationKey, forKey: .authenticationKey)
        try container.encode(pan, forKey: .pan)
        try container.encode(tokenScheme.description, forKey: .tokenScheme)
    }

    deinit {}
}
