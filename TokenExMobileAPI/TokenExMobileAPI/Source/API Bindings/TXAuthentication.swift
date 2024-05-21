import Foundation

/// Authentication data required for TokenEx Mobile API calls.
///
/// Consists of a timestamp when the authentication was provided and a generated authentication key.
/// The authentication is valid for up to 20 minutes.
@objc
public class TXAuthentication: NSObject {
    private static var dateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(abbreviation: "UTC")
        f.dateFormat = "yyyyMMddHHmmss"
        return f
    }()

    /// Authentication key.
    @objc public let key: String
    /// Timestamp sent by the server when the authentication was created.
    @objc public let timestamp: Date

    /// Timestamp in the format the TokenEx Mobile API requires.
    @objc public var formattedTimestamp: String {
        Self.formatDate(timestamp)
    }

    override public var debugDescription: String {
        "<TXAuthentication: key=\(key) timestamp=\(timestamp.debugDescription)>"
    }

    /// Initialize a new authentication with the given ``key`` and ``timestamp``.
    @objc(initWithKey:timestamp:)
    public init(key: String, timestamp: Date) {
        self.key = key
        self.timestamp = timestamp
    }

    /// Format any date in the format the TokenEx Mobile API requires.
    @objc
    public static func formatDate(_ from: Date) -> String {
        Self.dateFormatter.string(from: from)
    }

    deinit {}
}
