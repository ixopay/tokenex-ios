import Foundation

/// Type of SDK configuration error.
public enum ConfigurationErrorType {
    /// No TokenEx ID was configured.
    ///
    /// Set it on ``TokenExMobileAPI/defaultTokenExID`` or during initialization of the
    /// ``TXMobileAPIClient/init(tokenExID:authenticationKeyProvider:tokenHMACProvider:environment:)``.
    case noTokenExId
    /// No ``TXAuthenticationKeyProvider`` was configured.
    ///
    /// Set it on ``TokenExMobileAPI/defaultAuthenticationKeyProvider`` or during initialization of
    /// ``TXMobileAPIClient/init(tokenExID:authenticationKeyProvider:tokenHMACProvider:environment:)``.
    case noAuthenticationProvider
}

/// Errors returned by ``TXMobileAPIClient``
public enum TokenExError: Error, CustomNSError {
    case internalError(_ error: (any Error)? = nil)
    case invalidConfiguration(ConfigurationErrorType)
    case authenticationProviderError(_ error: any Error)
    case tokenHMACProviderError(_ error: any Error)
    case tokenHMACMismatchError(token: String, hmacFromAPI: String, hmacFromProvider: String)
    case apiError(_ error: (any Error)? = nil)

    public static var errorDomain: String { TXError.tokenExDomain }

    public var errorCode: Int {
        switch self {
        case .internalError:
            TXErrorCode.internalError.rawValue

        case .invalidConfiguration(let configurationErrorType):
            switch configurationErrorType {
            case .noTokenExId:
                TXErrorCode.configurationErrorNoTokenExId.rawValue

            case .noAuthenticationProvider:
                TXErrorCode.configurationErrorNoAuthenticationProvider.rawValue
            }

        case .authenticationProviderError:
            TXErrorCode.authenticationProviderError.rawValue

        case .tokenHMACProviderError:
            TXErrorCode.tokenHMACProviderError.rawValue

        case .tokenHMACMismatchError:
            TXErrorCode.tokenHMACMismatchError.rawValue

        case .apiError:
            TXErrorCode.apiError.rawValue
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        switch self {
        case .internalError(let error), .apiError(let error):
            if let error {
                [
                    NSUnderlyingErrorKey: error
                ]
            } else {
                [:]
            }

        case .invalidConfiguration, .tokenHMACMismatchError:
            [:]

        case .authenticationProviderError(let error), .tokenHMACProviderError(let error):
            [
                NSUnderlyingErrorKey: error
            ]
        }
    }
}
