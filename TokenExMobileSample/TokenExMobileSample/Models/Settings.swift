import Foundation
import TokenExMobileAPI

internal class Settings: ObservableObject {
    @Published internal var tokenExID: String {
        didSet {
            mobileApiClient.tokenExID = tokenExID
        }
    }
    @Published internal var environment: TokenExMobileAPIEnvironment {
        didSet {
            mobileApiClient.environment = environment
        }
    }
    @Published internal var customerSecretKeyForMobileAPI: String {
        didSet {
            insecureLocalSecretServer.insecureCustomerSecretKey = customerSecretKeyForMobileAPI
        }
    }

    private var insecureLocalSecretServer: TXInsecureLocalSecretServer
    internal private(set) var mobileApiClient: TXMobileAPIClient

    internal init() {
        tokenExID = kConfig.tokenExID ?? ""
        environment = kConfig.environment
        customerSecretKeyForMobileAPI = kConfig.insecureCustomerSecretKey ?? ""
        insecureLocalSecretServer = TXInsecureLocalSecretServer(
            insecureCustomerSecretKey: kConfig.insecureCustomerSecretKey
        )
        mobileApiClient = TXMobileAPIClient(
            tokenExID: kConfig.tokenExID ?? "<unset>",
            authenticationKeyProvider: insecureLocalSecretServer,
            tokenHMACProvider: insecureLocalSecretServer,
            environment: kConfig.environment
        )
    }

    deinit {}
}
