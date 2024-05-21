import Foundation
@testable import TokenExMobileAPI

internal typealias ConstantTokenHMACProviderHook = (_ tokenExID: String, _ token: String) throws -> Void

internal class ConstantTokenHMACProvider: TXTokenHMACProvider {
    private let hmac: String
    private let hook: ConstantTokenHMACProviderHook?

    internal init(hmac: String, hook: ConstantTokenHMACProviderHook? = nil) {
        self.hmac = hmac
        self.hook = hook
    }

    internal func fetchHMAC(tokenExID: String, token: String) throws -> String {
        try hook?(tokenExID, token)

        return hmac
    }

    deinit {}
}
