import Foundation  // swiftlint:disable:this file_name

/// A callback to be run with a token response from the TokenEx Mobile API.
/// - Parameters:
///   - tokenResponse: Token response. Will be nil if an error occurs.
///   - error: The error returned from the response, or nil if none occurs.
public typealias TXTokenResponseCompletionBlock = (TXTokenResponse?, Error?) -> Void

/// A callback to be run with a BIN lookup response from the TokenEx Mobile API.
/// - Parameters:
///   - tokenResponse: BIN lookup response. Will be nil if an error occurs.
///   - error: The error returned from the response, or nil if none occurs.
public typealias TXBINLookupResponseCompletionBlock = (TXBINLookupResponse?, Error?) -> Void
