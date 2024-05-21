import Foundation

internal enum TokenExResult<Response> {
    case uninitialized
    case processing
    case success(Response)
    case error(Error)

    internal var isProcessing: Bool {
        if case .processing = self {
            return true
        }

        return false
    }
}
