import SwiftUI

internal struct ContentView: View {
    internal var body: some View {
        TabView {
            TokenizeView()
                .tabItem {
                    Label("Tokenize", systemImage: "creditcard")
                }

            TokenizeWithCVVView()
                .tabItem {
                    Label("Tokenize with CVV", systemImage: "creditcard.and.123")
                }

            TokenizeCVVView()
                .tabItem {
                    Label("Tokenize CVV", systemImage: "123.rectangle")
                }

            BINLookupView()
                .tabItem {
                    Label("BIN Lookup", systemImage: "creditcard.viewfinder")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView().environmentObject(Settings())
}
