# ``TokenExMobileAPI``

The TokenEx Mobile API serves as an endpoint for customers who wish to tokenize data from within native mobile applications.
The TokenEx Mobile API is built to be easily integrated with your existing mobile application as a JSON Web API.
With it, you can make calls to tokenize data (Tokenize), associate a CVV with an existing credit card token TokenizeCVV,
or do both at the same time TokenizeWithCVV.
Each call to the service will return a JSON object containing the information returned by TokenEx.

## Integration

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
