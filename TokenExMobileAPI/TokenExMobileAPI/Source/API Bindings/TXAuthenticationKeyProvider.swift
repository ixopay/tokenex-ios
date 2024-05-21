import Foundation

/// An implementation of this protocol should call **your API backend** to generate an authentication key.
///
/// See [Generating the Authentication Key](https://docs.tokenex.com/docs/generating-the-authentication-key-1).
@objc
public protocol TXAuthenticationKeyProvider {
    /// Fetches an authentication key from the server using the provided parameters.
    ///
    /// - Parameters:
    ///   - tokenExID: Your TokenEx ID.
    ///   - tokenSchemeOrToken: The token scheme (e.g., "sixTOKENfour") or the token value depending on the API call.
    /// - Throws: Any error that may occur during key retrieval.
    /// - Returns: The fetched authentication key as a Base64-encoded string.
    func fetchAuthenticationKey(tokenExID: String, tokenSchemeOrToken: String) throws -> TXAuthentication
}
