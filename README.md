# TokenEx iOS SDK

[![CocoaPods](https://img.shields.io/cocoapods/v/TokenExMobileAPI.svg?style=flat)](http://cocoapods.org/pods/TokenExMobileAPI)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/TokenExMobileAPI.svg?style=flat)](https://github.com/ixopay/tokenex-ios/blob/main/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/TokenExMobileAPI.svg?style=flat)](https://github.com/ixopay/tokenex-ios#)

The TokenEx iOS SDK makes it simple to access the TokenEx Mobile API from any Swift or Objective-C project.

## Getting started

### Add the framework

Add the framework to your project:

- Swift Package Manager (SPM, SwiftPM): Add the URL of this repository as Package Dependency
  1. Select your XCode project in the Project navigator.
  2. Make sure the Project is selected in the Editor and switch to the tab "Package Dependencies".
  3. Click "+" and enter `https://github.com/ixopay/tokenex-ios.git` in the top right.
  4. Click "Add Package"
- CocoaPods:

  1. Create a Podfile: `pod init`
  2. Edit the Podfile to add a dependency:

  ```ruby
  target 'MyExampleProject' do
    use_frameworks!

    pod 'TokenExMobileAPI', '~> 1.0.0'
  end
  ```

  3. Install your project dependencies:

  ```bash
  pod install
  ```

  4. Re-open your XCode project:

  ```bash
  open ./MyExampleProject.xcworkspace
  ```

- Carthage:

  1. Create a `Cartfile` in your project directory:

  ```
  github "ixopay/tokenex-ios.git" ~> 1.0.0
  ```

  2. Run:

  ```bash
  carthage update --use-xcframeworks
  ```

  3. Add the built package in `./Carthage/Build/TokenExMobileAPI.xcframework` as framework dependency to your app.

### Integration

1. Provide your TokenEx ID:

   ```swift

   // Make sure the environment matches your TokenEx ID
   // i.e. for test IDs use the test environment, the default is the production environment
   TokenExMobileAPI.defaultEnvironment = TokenExMobileAPIEnvironment.production
   TokenExMobileAPI.defaultTokenExID = "YourTokenExID"
   ```

2. Implement the protocol `TXAuthenticationKeyProvider`.
   The implementation should call your backend server to get an authentication key.

   ```swift
   internal class MyMerchantBackendAuthenticationKeyProvider : TXAuthenticationKeyProvider {
     internal func fetchAuthenticationKey(tokenExID: String, tokenSchemeOrToken: String) throws -> TXAuthentication {
       // Call your backend server with the tokenSchemeOrToken (and optionally your TokenEx ID to help you identify the client secret key)
       // For example code for your backend see https://docs.tokenex.com/docs/generating-the-authentication-key-1

       return TXAuthentication(key: "HMAC_RETURNED_BY_YOUR_SERVER", timestamp: TIMESTAMP_RETURNED_BY_YOUR_SERVER)
     }
   }
   ```

   Then configure the API client to use it:

   ```swift
   TokenExMobileAPI.defaultAuthenticationKeyProvider = MyMerchantBackendAuthenticationKeyProvider()
   ```

   3. Use the `TXMobileAPIClient`:

   ```swift
   let tokenResponse = try await TXMobileAPIClient.shared.tokenizeWithCVV(
     TXTokenizeCVVRequest(
       data: "5454545454545454",
       tokenScheme: TXTokenScheme.PCI,
       cvv: "123"
     )
   )

   print(tokenResponse.token)
   ```

Optionally, you can also provide a `TokenExMobileAPI.defaultTokenHMACProvider` that implements `TXTokenHMACProvider` and uses your backend to generate HMACs to validate TokenEx responses. See [Validating the Token HMAC](https://docs.tokenex.com/docs/validating-the-token-hmac) for more details.

_Note:_ It's also possible to instantiate a `TXMobileAPIClient` without using the default values in `TokenExMobileAPI`.

## Example

This project contains an example iOS app in [TokenExMobileSample](TokenExMobileSample/).

To use the demo app you need to provide your TokenEx ID and customer secret key in one of two ways:

1. [Edit your XCode build scheme](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project#Specify-launch-arguments-and-environment-variables) to include the environment variables:
   ```bash
   APP_ENVIRONMENT="local"
   TOKENEX_ID="YourTokenExID"
   TOKENEX_ENVIRONMENT="test" # or production
   TOKENEX_CUSTOMER_SECRET="Customer secret from portal"
   ```
2. Enter your login credentials in the Settings tab inside the app.

## Code style

- We use [swiftlint](https://github.com/realm/SwiftLint) to enforce code style.
- Install switflint with `brew install swiftlint`
- Install just

## License

[MIT](./LICENSE)
