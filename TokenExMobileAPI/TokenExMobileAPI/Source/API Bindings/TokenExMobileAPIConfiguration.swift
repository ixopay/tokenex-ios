import Foundation

/// Shared configuration for TokenEx Mobile API
@_spi(TX)
public enum TokenExMobileAPIConfiguration {
    /// Shared ``URLSession`` configuration
    public static let sharedUrlSessionConfiguration = URLSessionConfiguration.default
}
