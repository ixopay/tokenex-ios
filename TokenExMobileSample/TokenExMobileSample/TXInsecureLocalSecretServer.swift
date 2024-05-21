import CommonCrypto
import Foundation
import os
import SwiftUI
import TokenExMobileAPI

internal class TXInsecureLocalSecretServer: TXAuthenticationKeyProvider, TXTokenHMACProvider, ObservableObject {
    private static var logger = Logger(
        subsystem: "com.tokenex.mobile-api.demo-app",
        category: "authentication-provider"
    )

    internal var insecureCustomerSecretKey: String?

    internal init(insecureCustomerSecretKey: String? = nil) {
        self.insecureCustomerSecretKey = insecureCustomerSecretKey
    }

    internal func fetchAuthenticationKey(tokenExID: String, tokenSchemeOrToken: String) throws -> TXAuthentication {
        let timestamp = Date()

        guard let insecureCustomerSecretKey else {
            throw TokenExError.internalError()
        }

        let info = "\(tokenExID)|\(TXAuthentication.formatDate(timestamp))|\(tokenSchemeOrToken)"
        let hmac = try generateHMAC(concatenatedInfo: info, clientSecretKey: insecureCustomerSecretKey)

        return TXAuthentication(key: hmac, timestamp: timestamp)
    }

    internal func fetchHMAC(tokenExID: String, token: String) throws -> String {
        guard let insecureCustomerSecretKey else {
            throw TokenExError.internalError()
        }

        return try generateHMAC(concatenatedInfo: token, clientSecretKey: insecureCustomerSecretKey)
    }

    private func generateHMAC(concatenatedInfo: String, clientSecretKey: String) throws -> String {
        let hmacData = concatenatedInfo.data(using: .utf8)!
        let keyData = clientSecretKey.data(using: .utf8)!

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        hmacData.withUnsafeBytes { hmacDataBytes in
            keyData.withUnsafeBytes { keyDataBytes in
                CCHmac(
                    CCHmacAlgorithm(kCCHmacAlgSHA256),
                    keyDataBytes.baseAddress!,
                    keyData.count,
                    hmacDataBytes.baseAddress!,
                    hmacData.count,
                    &digest
                )
            }
        }

        let hmac = Data(digest).base64EncodedString()

        Self.logger.info(
            "generateHMAC: concatenatedInfo=\(concatenatedInfo) clientSecretKey=\(clientSecretKey) HMAC=\(hmac)"
        )

        return hmac
    }

    deinit {}
}
