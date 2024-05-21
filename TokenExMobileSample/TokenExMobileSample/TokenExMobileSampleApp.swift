import SwiftUI
import TokenExMobileAPI

@main
internal struct TokenExMobileSampleApp: App {
    @StateObject private var settings = Settings()

    internal var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(settings)
        }
    }
}
