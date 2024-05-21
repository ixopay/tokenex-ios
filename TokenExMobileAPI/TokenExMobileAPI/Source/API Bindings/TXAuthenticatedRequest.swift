import Foundation

/// Base class for an authenticated requests to the TokenEx Mobile API.
@objc
public class TXAuthenticatedRequest: NSObject, Encodable {
    internal enum CodingKeys: String, CodingKey {
        case tokenExID = "TokenExID"
        case timestamp = "Timestamp"
        case authenticationKey = "AuthenticationKey"
    }

    public private(set) var tokenExID: String?
    public private(set) var timestamp: String?
    public private(set) var authenticationKey: String?

    @objc(initWithTokenExID:authentication:)
    public convenience init(tokenExID: String, authentication: TXAuthentication) {
        self.init(
            tokenExID: tokenExID,
            timestamp: authentication.formattedTimestamp,
            authenticationKey: authentication.key
        )
    }

    internal init(tokenExID: String? = nil, timestamp: String? = nil, authenticationKey: String? = nil) {
        self.tokenExID = tokenExID
        self.timestamp = timestamp
        self.authenticationKey = authenticationKey
    }

    @objc(applyAuthenticationWithTokenExID:authentication:)
    public func applyAuthentication(tokenExID: String, authentication: TXAuthentication) {
        self.tokenExID = tokenExID
        self.timestamp = authentication.formattedTimestamp
        self.authenticationKey = authentication.key
    }

    @objc(applyAuthenticationWithTokenExID:timestamp:authenticationKey:)
    public func applyAuthentication(tokenExID: String, timestamp: String, authenticationKey: String) {
        self.tokenExID = tokenExID
        self.timestamp = timestamp
        self.authenticationKey = authenticationKey
    }

    deinit {}
}
