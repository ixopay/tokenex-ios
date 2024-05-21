import Foundation

@objc
public enum TokenExMobileAPIEnvironment: Int {
    case test = 0
    case production = 1
}

/// Configuration constants affecting ``TXMobileAPIClient``.
@objc
public class TokenExMobileAPISettings: NSObject {
    /// Set the environment to use (testing or production)
    ///
    /// Set this early in the application lifecycle.
    /// New instances of the API client will be initialized with this value.
    @objc public static var defaultEnvironment = TokenExMobileAPIEnvironment.production

    /// Set this to your TokenEx ID.
    ///
    /// Set this early in the application lifecycle.
    /// New instances of the API client will be initialized with this value.
    @objc public static var defaultTokenExID: String?

    /// Set this to your authentication key provider.
    ///
    /// This should call your backend to generate an authentication key for use with the
    /// TokenEx Mobile API.
    ///
    /// Set this early in the application lifecycle. New instances of the API client will be
    /// initialized with this value.
    @objc public static var defaultAuthenticationKeyProvider: TXAuthenticationKeyProvider?

    /// Optionally set this to your token HMAC provider.
    ///
    /// This should call your backend to calculate an HMAC-SHA256 to validate tokens returned
    /// by the TokenEx Mobile API are valid.
    /// If not set, no such client-side validation will take place.
    ///
    /// Set this early in the application lifecycle. New instances of the API client will be
    /// initialized with this value.
    @objc public static var defaultTokenHMACProvider: TXTokenHMACProvider?

    override private init() {}

    deinit {}
}
