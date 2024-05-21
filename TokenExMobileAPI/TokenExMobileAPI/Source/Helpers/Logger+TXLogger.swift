import Foundation
import OSLog

extension Logger {
    private static var subsystem = "com.tokenex.mobile-api"

    internal static let http = Logger(subsystem: subsystem, category: "http")
    internal static let provider = Logger(subsystem: subsystem, category: "provider")
    internal static let core = Logger(subsystem: subsystem, category: "core")
}
