import Foundation
import os

extension TXMobileAPIClient {
    /// Generate a token based on the provided token scheme and data to be tokenized and
    /// simultaneously associated a CVV with its generated token.
    ///
    /// - Parameter request: The tokenization request, provide the ``TXTokenizeWithCVVRequest/data``
    ///   to tokenize. The resulting ``TXTokenResponse/token`` will be formatted according to the
    ///   ``TXTokenizeWithCVVRequest/tokenScheme`` provided. Simultaneously associate
    ///   ``TXTokenizeWithCVVRequest/cvv`` with the token.
    /// - Parameter completion: The callback to run with the returned ``TXTokenResponse`` object,
    ///   or an error.
    @objc(tokenizeWithCVV:completion:)
    public func tokenizeWithCVV(
        _ request: TXTokenizeWithCVVRequest,
        completion: @escaping TXTokenResponseCompletionBlock
    ) {
        do {
            let authentication = try self.fetchAuthenticationKey(
                tokenSchemeOrToken: request.tokenScheme.description
            )

            request.authentication = TXAuthenticatedRequest(
                tokenExID: self.tokenExID!,
                authentication: authentication
            )

            self.post(path: "/TokenizeWithCVV", object: request) { (result: Result<TXTokenResponse, Error>) in
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

    /// Async helper version of ``tokenizeWithCVV(_:completion:)``.
    public func tokenizeWithCVV(_ request: TXTokenizeWithCVVRequest) async throws -> TXTokenResponse {
        try await withCheckedThrowingContinuation { continuation in
            tokenizeWithCVV(request) { responseObject, error in
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
