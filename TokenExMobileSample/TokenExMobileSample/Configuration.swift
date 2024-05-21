import Foundation
import TokenExMobileAPI

internal protocol Configuration {
    var tokenExID: String? { get }
    var environment: TokenExMobileAPIEnvironment { get }
    var insecureCustomerSecretKey: String? { get }
}

internal class EnvironmenVariableConfiguration: Configuration {
    private static let KeyTokenExID = "TOKENEX_ID"
    private static let KeyEnvironment = "TOKENEX_ENVIRONMENT"
    private static let KeyCustomerSecret = "TOKENEX_CUSTOMER_SECRET"

    private var defaultEnvironment: TokenExMobileAPIEnvironment

    internal var tokenExID: String? {
        ProcessInfo.processInfo.environment[Self.KeyTokenExID]
    }

    internal var environment: TokenExMobileAPIEnvironment {
        guard let environment = ProcessInfo.processInfo.environment[Self.KeyEnvironment] else {
            return .test
        }
        switch environment {
        case "test":
            return .test

        case "production":
            return .production

        default:
            fatalError("Environment variable is invalid: \(Self.KeyEnvironment)")
        }
    }

    internal var insecureCustomerSecretKey: String? {
        ProcessInfo.processInfo.environment[Self.KeyCustomerSecret]
    }

    internal init(defaultEnvironment: TokenExMobileAPIEnvironment) {
        self.defaultEnvironment = defaultEnvironment
    }

    deinit {}
}

internal class EmptyConfiguration: Configuration {
    private var defaultEnvironment: TokenExMobileAPIEnvironment

    internal var tokenExID: String? { nil }
    internal var environment: TokenExMobileAPIEnvironment { defaultEnvironment }
    internal var insecureCustomerSecretKey: String? { nil }

    internal init(defaultEnvironment: TokenExMobileAPIEnvironment) {
        self.defaultEnvironment = defaultEnvironment
    }

    deinit {}
}

internal let kEnvironment: String = ProcessInfo.processInfo.environment["APP_ENVIRONMENT"] ?? "development"

internal let kConfig: Configuration =
    switch kEnvironment {
    case "production":
        EmptyConfiguration(defaultEnvironment: .production)

    case "staging":
        EmptyConfiguration(defaultEnvironment: .test)

    case "local":
        EnvironmenVariableConfiguration(defaultEnvironment: .test)

    default:
        EnvironmenVariableConfiguration(defaultEnvironment: .test)
    }
