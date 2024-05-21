import Foundation

/// Simultaneously tokenize a data element and associate a CVV with its generated token.
@objc
public class TXTokenizeWithCVVRequest: NSObject, Encodable {
    private enum CodingKeys: String, CodingKey {
        case tokenExID = "TokenExID"
        case timestamp = "Timestamp"
        case authenticationKey = "AuthenticationKey"

        case data = "Data"
        case tokenScheme = "TokenScheme"
        case cvv = "CVV"
        case useExtendedBIN = "UseExtendedBIN"
    }

    internal var authentication: TXAuthenticatedRequest?

    /// The data to be tokenized.
    @objc public let data: String

    /// The Token Scheme to be used to tokenize the provided data.
    @objc public let tokenScheme: TXTokenScheme

    /// The CVV to be associated with the provided Token.
    @objc public let cvv: String

    /// Optional parameter: Allows for 8 digit BIN to be returned in the tokenize response
    /// (Only available for PCI token scheme). Defaults to false.
    @objc public let useExtendedBIN: Bool

    @objc(initWithData:tokenScheme:cvv:useExtendedBIN:)
    public init(data: String, tokenScheme: TXTokenScheme, cvv: String, useExtendedBIN: Bool = false) {
        self.data = data
        self.tokenScheme = tokenScheme
        self.cvv = cvv
        self.useExtendedBIN = useExtendedBIN
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        guard let authentication else {
            throw TokenExError.internalError()
        }

        try container.encode(authentication.tokenExID, forKey: .tokenExID)
        try container.encode(authentication.timestamp, forKey: .timestamp)
        try container.encode(authentication.authenticationKey, forKey: .authenticationKey)

        try container.encode(self.data, forKey: .data)
        try container.encode(self.tokenScheme.description, forKey: .tokenScheme)
        try container.encode(self.cvv, forKey: .cvv)
        if self.useExtendedBIN {
            try container.encode(self.useExtendedBIN, forKey: .useExtendedBIN)
        }
    }

    deinit {}
}
