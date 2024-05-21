import Foundation

/// Framework error codes.
@objc
public enum TXErrorCode: Int {
    /// Error internal to the SDK.
    @objc(TXInternalError) case internalError = 10
    /// No TokenEx ID was configured.
    ///
    /// Set it on ``TokenExMobileAPI/defaultTokenExID`` or during initialization of the
    /// ``TXMobileAPIClient/init(tokenExID:authenticationKeyProvider:tokenHMACProvider:environment:)``.
    @objc(TXConfigurationErrorNoTokenExId) case configurationErrorNoTokenExId = 21
    /// No ``TXAuthenticationKeyProvider`` was configured.
    ///
    /// Set it on ``TokenExMobileAPI/defaultAuthenticationKeyProvider`` or during initialization of
    /// ``TXMobileAPIClient/init(tokenExID:authenticationKeyProvider:tokenHMACProvider:environment:)``.
    @objc(TXConfigurationErrorNoAuthenticationProvider) case configurationErrorNoAuthenticationProvider = 22
    /// If the configuraed ``TXAuthenticationKeyProvider`` throws an error.
    @objc(TXAuthenticationProviderError) case authenticationProviderError = 31
    /// If the configuraed ``TXTokenHMACProvider`` throws an error.
    @objc(TXTokenHMACProviderError) case tokenHMACProviderError = 32
    /// If a token HMAC provider is configured and the returned token doesn't match the calculated token,
    /// this error is raised.
    @objc(TXTokenHMACMismatchError) case tokenHMACMismatchError = 50
    /// Error returned by the API.
    @objc(TXAPIError) case apiError = 60
}

/// Top-level class for TokenEx error constants.
@objc
public class TXError: NSObject {
    /// Domain for `NSError` instances.
    @objc public static let tokenExDomain = "com.tokenex.lib"

    deinit {}
}
