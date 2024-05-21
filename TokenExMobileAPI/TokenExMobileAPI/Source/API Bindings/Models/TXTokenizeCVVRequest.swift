import Foundation

/// Associate a CVV value with a previously-generated token.
@objc
public class TXTokenizeCVVRequest: NSObject, Encodable {
    private enum CodingKeys: String, CodingKey {
        case tokenExID = "TokenExID"
        case timestamp = "Timestamp"
        case authenticationKey = "AuthenticationKey"

        case token = "Token"
        case cvv = "CVV"
    }

    internal var authentication: TXAuthenticatedRequest?

    /// The token for the previously-tokenized data with which you wish to associate a CVV.
    @objc public let token: String

    /// The CVV to be associated with the provided Token.
    @objc public let cvv: String

    @objc(initWithToken:cvv:)
    public init(token: String, cvv: String) {
        self.token = token
        self.cvv = cvv
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        guard let authentication else {
            throw TokenExError.internalError()
        }

        try container.encode(authentication.tokenExID, forKey: .tokenExID)
        try container.encode(authentication.timestamp, forKey: .timestamp)
        try container.encode(authentication.authenticationKey, forKey: .authenticationKey)

        try container.encode(self.token, forKey: .token)
        try container.encode(self.cvv, forKey: .cvv)
    }

    deinit {}
}
