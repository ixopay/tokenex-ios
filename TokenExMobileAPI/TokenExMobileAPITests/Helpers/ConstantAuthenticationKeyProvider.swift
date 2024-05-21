import Foundation
@testable import TokenExMobileAPI

internal typealias ConstantAuthenticationKeyProviderHook =
    (_ tokenExID: String, _ tokenSchemeOrToken: String) throws -> Void

internal class ConstantAuthenticationKeyProvider: TXAuthenticationKeyProvider {
    private let key: String
    private let timestamp: Date
    private let hook: ConstantAuthenticationKeyProviderHook?

    internal init(key: String, timestamp: Date, hook: ConstantAuthenticationKeyProviderHook? = nil) {
        self.key = key
        self.timestamp = timestamp
        self.hook = hook
    }

    internal func fetchAuthenticationKey(tokenExID: String, tokenSchemeOrToken: String) throws -> TXAuthentication {
        try hook?(tokenExID, tokenSchemeOrToken)

        return TXAuthentication(key: key, timestamp: timestamp)
    }

    deinit {}
}
