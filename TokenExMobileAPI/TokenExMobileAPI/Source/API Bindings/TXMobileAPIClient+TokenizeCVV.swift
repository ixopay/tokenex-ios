import Foundation
import os

extension TXMobileAPIClient {
    /// Associate a CVV value with a previously-generated token.
    ///
    /// - Parameter request: The tokenization request, provide the ``TXTokenizeCVVRequest/cvv``
    ///   to associated with the ``TXTokenizeCVVRequest/token``. The token with the associated CVV will be returned.
    /// - Parameter completion: The callback to run with the returned ``TXTokenResponse`` object,
    ///   or an error.
    @objc(tokenizeCVV:completion:)
    public func tokenizeCVV(
        _ request: TXTokenizeCVVRequest,
        completion: @escaping TXTokenResponseCompletionBlock
    ) {
        do {
            let authentication = try self.fetchAuthenticationKey(
                tokenSchemeOrToken: request.token
            )

            request.authentication = TXAuthenticatedRequest(
                tokenExID: self.tokenExID!,
                authentication: authentication
            )

            self.post(path: "/TokenizeCVV", object: request) { (result: Result<TXTokenResponse, Error>) in
                switch result {
                case .success(let token):
                    do {
                        if let tokenHMAC = token.tokenHMAC, let token = token.token {
                            try self.validateTokenHMACIfEnabled(token: token, receivedTokenHMAC: tokenHMAC)
                        }
                        completion(token, nil)
                    } catch {
                        completion(nil, error)
                    }

                case .failure(let error):
                    completion(nil, error)
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }

    /// Async helper version of ``tokenizeCVV(_:completion:)``.
    public func tokenizeCVV(_ request: TXTokenizeCVVRequest) async throws -> TXTokenResponse {
        try await withCheckedThrowingContinuation { continuation in
            tokenizeCVV(request) { responseObject, error in
                guard let responseObject else {
                    continuation.resume(
                        throwing: error ?? TokenExError.internalError()
                    )
                    return
                }
                continuation.resume(returning: responseObject)
            }
        }
    }
}
