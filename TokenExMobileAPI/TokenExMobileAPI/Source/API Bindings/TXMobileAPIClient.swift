import Foundation
import OSLog
import UIKit

/// Client to access the [TokenEx Mobile API](https://docs.tokenex.com/docs/tokenex-mobile-api).
@objc
public class TXMobileAPIClient: NSObject {
    /// The current version of this library.
    @objc public static let TXSDKVersion: String = TokenExMobileAPIConfiguration.TXSDKVersion

    /// A shared singleton API client.
    @objc(sharedClient) public static let shared: TXMobileAPIClient = {
        TXMobileAPIClient()
    }()

    /// Shared encoder
    @_spi(TX) public static var encoder = JSONEncoder()

    /// Shared decoder
    @_spi(TX) public static var decoder = JSONDecoder()

    /// The client's environment, either ``TokenExMobileAPIEnvironment/production`` or
    /// ``TokenExMobileAPIEnvironment/test``.
    ///
    /// The default value is `TokenExMobileAPI.defaultEnvironment`.
    @objc public var environment: TokenExMobileAPIEnvironment {
        get {
            if let environment = _environment {
                return environment
            }
            return TokenExMobileAPISettings.defaultEnvironment
        }
        set {
            _environment = newValue
        }
    }

    private var _environment: TokenExMobileAPIEnvironment?

    /// The client's TokenEx ID.
    ///
    /// The default value is ``TokenExMobileAPI/defaultTokenExID``.
    @objc public var tokenExID: String? {
        get {
            if let tokenExID = _tokenExID {
                return tokenExID
            }
            return TokenExMobileAPISettings.defaultTokenExID
        }
        set {
            _tokenExID = newValue
        }
    }

    private var _tokenExID: String?

    /// The client's authentication key provider.
    ///
    /// The default value is ``TokenExMobileAPI/defaultAuthenticationKeyProvider``.
    @objc public var authenticationKeyProvider: TXAuthenticationKeyProvider? {
        get {
            if let authenticationKeyProvider = _authenticationKeyProvider {
                return authenticationKeyProvider
            }
            return TokenExMobileAPISettings.defaultAuthenticationKeyProvider
        }
        set {
            _authenticationKeyProvider = newValue
        }
    }

    private var _authenticationKeyProvider: TXAuthenticationKeyProvider?

    /// The client's token HMAC provider.
    ///
    /// The default value is `TokenExMobileAPI.defaultAuthenticationKeyProvider`.
    @objc public var tokenHMACProvider: TXTokenHMACProvider? {
        get {
            if let tokenHMACProvider = _tokenHMACProvider {
                return tokenHMACProvider
            }
            return TokenExMobileAPISettings.defaultTokenHMACProvider
        }
        set {
            _tokenHMACProvider = newValue
        }
    }

    private var _tokenHMACProvider: TXTokenHMACProvider?

    /// The API URL used to access the TokenEx Mobile API. The value depends on the value of ``environment``.
    @objc public var apiURL: URL {
        switch self.environment {
        case .test:
            kTestMobileAPIBaseURL

        case .production:
            kMobileAPIBaseURL
        }
    }
    @_spi(TX) public var urlSession = URLSession(
        configuration: TokenExMobileAPIConfiguration.sharedUrlSessionConfiguration
    )

    /// Initializes an API client with the given TokenEx ID, authentication provider and environment.
    ///
    /// - Parameter tokenExID: The TokenEx ID.
    /// - Parameter authenticationKeyProvider: Provider of authentication keys.
    /// - Parameter tokenHMACProvider: Provider for token HMAC validation.
    /// - Parameter environment: Environment to use.
    /// - Returns: An instance of ``TXMobileAPIClient``.
    @objc(initWithTokenExID:authenticationKeyProvider:tokenHMACProvider:environment:)
    public convenience init(
        tokenExID: String,
        authenticationKeyProvider: TXAuthenticationKeyProvider,
        tokenHMACProvider: TXTokenHMACProvider? = nil,
        environment: TokenExMobileAPIEnvironment = .production
    ) {
        self.init()
        self.tokenExID = tokenExID
        self.authenticationKeyProvider = authenticationKeyProvider
        self.tokenHMACProvider = tokenHMACProvider
        self.environment = environment
    }

    /// Decode the JSON response.
    @_spi(TX)
    public static func decodeResponse<T: Decodable>(
        data: Data?,
        error: Error?,
        response: URLResponse?
    ) -> Result<T, Error> {
        if let error {
            return .failure(TokenExError.apiError(error))
        }
        guard let data else {
            return .failure(TokenExError.apiError())
        }

        if let response {
            Logger.http.debug(
                """
                --- RESPONSE[\(response.url?.description ?? "")] ---
                \(Self.formatStatusCode(response))
                \(Self.formatHeaders(response))

                \(String(decoding: data, as: UTF8.self), privacy: .sensitive)
                """
            )
        }

        do {
            let decodedObject: T = try decoder.decode(T.self, from: data)

            return .success(decodedObject)
        } catch {
            return .failure(TokenExError.apiError(error))
        }
    }

    /// Build a user agent string that can be used to analyze SDK usage.
    internal class func tokenExUserAgentDetails() -> String {
        var details: [String: String] = [
            "lang": "swift",
            "sdk_version": TXSDKVersion,
        ]
        let version = UIDevice.current.systemVersion
        if !version.isEmpty {
            details["os_version"] = version
        }
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceType = machineMirror.children.reduce(into: "") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return
            }
            identifier += String(UnicodeScalar(UInt8(value)))
        }
        details["type"] = deviceType
        let model = UIDevice.current.localizedModel
        if !model.isEmpty {
            details["model"] = model
        }

        if let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString {
            details["vendor_identifier"] = vendorIdentifier
        }
        let data = try? JSONSerialization.data(withJSONObject: details, options: [])
        return String(decoding: data ?? Data(), as: UTF8.self)
    }

    /// Debug format HTTP request headers.
    private static func formatHeaders(_ request: URLRequest) -> String {
        var formattedHeaders = ""
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            formattedHeaders += "\(key): \(value)\n"
        }
        return formattedHeaders.trimmingCharacters(in: .newlines)
    }

    /// Debug format HTTP response headers.
    private static func formatHeaders(_ response: URLResponse?) -> String {
        var formattedHeaders = ""

        guard let httpResponse = response as? HTTPURLResponse else {
            return ""
        }

        for (key, value) in httpResponse.allHeaderFields {
            formattedHeaders += "\(key): \(value)\n"
        }
        return formattedHeaders.trimmingCharacters(in: .newlines)
    }

    /// Debug format the HTTP response status code.
    private static func formatStatusCode(_ response: URLResponse?) -> String {
        guard let httpResponse = response as? HTTPURLResponse else {
            return ""
        }

        return "\(httpResponse.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
    }

    /// Build an HTTP request with the required headers.
    @_spi(TX)
    public func configuredRequest(for url: URL, additionalHeaders: [String: String] = [:]) -> URLRequest {
        var request = URLRequest(url: url)
        var headers = defaultHeaders()
        for (k, v) in additionalHeaders { headers[k] = v }
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    /// Post an encodable object ``object`` to ``path``, on completion parse the response as ``O``.
    @_spi(TX)
    public func post<I: Encodable, O: Decodable>(
        path: String,
        object: I,
        completion: @escaping (Result<O, Error>) -> Void
    ) {
        do {
            let url = apiURL.appendingPathComponent(path)
            let json = try Self.encoder.encode(object)
            var request = configuredRequest(
                for: url,
                additionalHeaders: [
                    "Content-Length": String(format: "%lu", UInt(json.count)),
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                ]
            )
            request.httpBody = json
            request.httpMethod = "POST"

            Logger.http.debug(
                """
                --- REQUEST ---
                \(request.httpMethod ?? "GET") \(url.path)
                Host: \(url.host ?? "")
                \(Self.formatHeaders(request))

                \(String(decoding: json, as: UTF8.self), privacy: .private)
                """
            )

            urlSession.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    completion(
                        Self.decodeResponse(data: data, error: error, response: response)
                    )
                }
            }
            .resume()
        } catch {
            DispatchQueue.main.async {
                completion(
                    .failure(TokenExError.internalError(error))
                )
            }
        }
    }

    @_spi(TX)
    public func fetchAuthenticationKey(tokenSchemeOrToken: String) throws -> TXAuthentication {
        guard let tokenExID else {
            throw TokenExError.invalidConfiguration(.noTokenExId)
        }

        guard let authenticationKeyProvider else {
            throw TokenExError.invalidConfiguration(.noAuthenticationProvider)
        }

        do {
            let authentication = try authenticationKeyProvider.fetchAuthenticationKey(
                tokenExID: tokenExID,
                tokenSchemeOrToken: tokenSchemeOrToken
            )

            Logger.provider.trace(
                // swiftlint:disable:next line_length
                "Received authentication=\(authentication.debugDescription, privacy: .private) for tokenSchemeOrToken=\(tokenSchemeOrToken, privacy: .private)"
            )

            return authentication
        } catch {
            throw TokenExError.authenticationProviderError(error)
        }
    }

    @_spi(TX)
    public func validateTokenHMACIfEnabled(token: String, receivedTokenHMAC: String) throws {
        guard let tokenExID else {
            throw TokenExError.invalidConfiguration(.noTokenExId)
        }

        guard let tokenHMACProvider else {
            return
        }

        let calculatedTokenHMAC: String
        do {
            calculatedTokenHMAC = try tokenHMACProvider.fetchHMAC(tokenExID: tokenExID, token: token)

            Logger.provider.trace("Received HMAC=\(calculatedTokenHMAC) for token=\(token, privacy: .private)")
        } catch {
            throw TokenExError.tokenHMACProviderError(error)
        }

        if calculatedTokenHMAC != receivedTokenHMAC {
            Logger.core.error(
                // swiftlint:disable:next line_length
                "Token mismatch, calculatedTokenHMAC=\(calculatedTokenHMAC) doesn't equal receivedTokenHMAC=\(receivedTokenHMAC) for token=\(token, privacy: .private)"
            )
            throw TokenExError.tokenHMACMismatchError(
                token: token,
                hmacFromAPI: receivedTokenHMAC,
                hmacFromProvider: calculatedTokenHMAC
            )
        }
    }

    /// Headers common to all API requests for a given API Client.
    internal func defaultHeaders() -> [String: String] {
        var defaultHeaders: [String: String] = [:]
        defaultHeaders["X-TokenEx-User-Agent"] = Self.tokenExUserAgentDetails()
        return defaultHeaders
    }

    deinit {}
}

private let kMobileAPIBaseURL = URL(string: "https://htp.tokenex.com/api/sdk")!
private let kTestMobileAPIBaseURL = URL(string: "https://test-htp.tokenex.com/api/sdk")!
