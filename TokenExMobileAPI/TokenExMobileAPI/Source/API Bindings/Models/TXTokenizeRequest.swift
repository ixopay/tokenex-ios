import Foundation

/// Generate a token based on the provided Token Scheme and data to be tokenized.
@objc
public class TXTokenizeRequest: NSObject, Encodable {
    private enum CodingKeys: String, CodingKey {
        case tokenExID = "TokenExID"
        case timestamp = "Timestamp"
        case authenticationKey = "AuthenticationKey"

        case data = "Data"
        case tokenScheme = "TokenScheme"
        case useExtendedBIN = "UseExtendedBIN"
    }

    internal var authentication: TXAuthenticatedRequest?

    /// The data to be tokenized.
    @objc public let data: String

    /// The Token Scheme to be used to tokenize the provided data.
    @objc public let tokenScheme: TXTokenScheme

    /// Optional parameter: Allows for 8 digit BIN to be returned in the tokenize response
    /// (Only available for PCI token scheme). Defaults to false.
    @objc public let useExtendedBIN: Bool

    @objc(initWithData:tokenScheme:useExtendedBIN:)
    public init(data: String, tokenScheme: TXTokenScheme, useExtendedBIN: Bool = false) {
        self.data = data
        self.tokenScheme = tokenScheme
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
        if self.useExtendedBIN {
            try container.encode(self.useExtendedBIN, forKey: .useExtendedBIN)
        }
    }

    deinit {}
}
