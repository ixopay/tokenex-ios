import Foundation

internal enum MockURLHandler {
    case uninitialized
    case error(Error)
    case request((URLRequest) throws -> (HTTPURLResponse, Data))
}

internal class MockURLProtocol: URLProtocol {
    internal static var urlHandler: MockURLHandler = .uninitialized

    override internal class func canInit(with request: URLRequest) -> Bool {
        switch request.url?.scheme {
        case "http", "https":
            true

        default:
            false
        }
    }

    override internal class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override internal func startLoading() {
        switch Self.urlHandler {
        case .uninitialized:
            client?.urlProtocol(self, didFailWithError: URLError(URLError.zeroByteResource))
            return

        case .error(let error):
            client?.urlProtocol(self, didFailWithError: error)
            return

        case .request(let handler):
            do {
                let (response, data) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override internal func stopLoading() {}

    deinit {}
}
