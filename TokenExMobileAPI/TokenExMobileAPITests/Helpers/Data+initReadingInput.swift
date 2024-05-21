import Foundation

extension Data {
    internal init?(reading input: InputStream?) throws {
        guard let input else {
            return nil
        }

        self.init()
        input.open()
        defer {
            input.close()
        }

        let bufferSize = 1_024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read < 0 {
                throw input.streamError!
            }
            if read == 0 {
                break
            }
            self.append(buffer, count: read)
        }
    }
}
