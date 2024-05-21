import Foundation
import os

extension TXMobileAPIClient {
    /// Generate a token based on the provided token scheme and data to be tokenized.
    ///
    /// - Parameter request: The tokenization request, provide the ``TXTokenizeRequest/data``
    ///   to tokenize. The resulting ``TXTokenResponse/token`` will be formatted according to the
    ///   ``TXTokenizeRequest/tokenScheme`` provided.
    /// - Parameter completion: The callback to run with the returned ``TXTokenResponse`` object,
    ///   or an error.
    @objc(tokenize:completion:)
    public func tokenize(
        _ request: TXTokenizeRequest,
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

            self.post(path: "/Tokenize", object: request) { (result: Result<TXTokenResponse, Error>) in
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

    /// Async helper version of ``tokenize(_:completion:)``.
    public func tokenize(_ request: TXTokenizeRequest) async throws -> TXTokenResponse {
        try await withCheckedThrowingContinuation { continuation in
            tokenize(request) { responseObject, error in
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
