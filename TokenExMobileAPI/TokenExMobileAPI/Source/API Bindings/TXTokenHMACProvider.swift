import Foundation

/// An implementation of this protocol should call **your API backend** to calculate an HMAC for the provided token.
///
/// See [Validating the Token HMAC](https://docs.tokenex.com/docs/validating-the-token-hmac).
@objc
public protocol TXTokenHMACProvider {
    /// Fetches the HMAC-SHA256 of the provided token.
    ///
    /// - Parameters:
    ///   - tokenExID: Your TokenEx ID.
    ///   - token: The token value to calculate the HMAC-SHA256 for.
    /// - Throws: Any error that may occur during calculation of the HMAC-SHA256.
    /// - Returns: The calculated HMAC-SHA256 of the provided token.
    func fetchHMAC(tokenExID: String, token: String) throws -> String
}
