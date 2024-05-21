import Foundation
import os

extension TXMobileAPIClient {
    /// Lookup information an account number in the bank identification number (BIN) database.
    ///
    /// - Parameter request: The BIN lookup request, provide the ``TXBINLookupRequest/pan``
    ///   to lookup. The resulting ``TXBINLookupResponse/binData`` contains the relevant response data.
    /// - Parameter completion: The callback to run with the returned ``TXBINLookupResponse`` object,
    ///   or an error.
    @objc(binLookup:completion:)
    public func binLookup(
        _ request: TXBINLookupRequest,
        completion: @escaping TXBINLookupResponseCompletionBlock
    ) {
        do {
            let authentication = try self.fetchAuthenticationKey(tokenSchemeOrToken: request.tokenScheme.description)

            request.authentication = TXAuthenticatedRequest(
                tokenExID: self.tokenExID!,
                authentication: authentication
            )

            self.post(path: "/BinLookup", object: request) { (result: Result<TXBINLookupResponse, Error>) in
                switch result {
                case .success(let bin):
                    completion(bin, nil)

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

    /// Async helper version of ``binLookup(_:completion:)``.
    public func binLookup(_ request: TXBINLookupRequest) async throws -> TXBINLookupResponse {
        try await withCheckedThrowingContinuation { continuation in
            binLookup(request) { responseObject, error in
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
