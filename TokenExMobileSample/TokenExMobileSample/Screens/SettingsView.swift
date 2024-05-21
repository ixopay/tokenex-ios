import SwiftUI
import TokenExMobileAPI

internal struct SettingsView: View {
    @EnvironmentObject internal var settings: Settings

    internal var body: some View {
        NavigationView {
            Form {
                Section(header: Text("TokenEx")) {
                    HStack {
                        Text("TokenEx ID")
                        Spacer()
                        TextField("TokenEx ID", text: $settings.tokenExID) { UIApplication.shared.endEditing() }
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section(header: Text("TokenEx Mobile API")) {
                    VStack(alignment: .leading) {
                        Picker("Environment", selection: $settings.environment) {
                            Text("Test").tag(TokenExMobileAPIEnvironment.test)
                            Text("Production").tag(TokenExMobileAPIEnvironment.production)
                        }
                        Text(settings.mobileApiClient.apiURL.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("Customer secret key for mobile API")
                        TextField("Customer secret key for mobile API", text: $settings.customerSecretKeyForMobileAPI) {
                            UIApplication.shared.endEditing()
                        }
                        .font(.system(.body, design: .monospaced))
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SettingsView().environmentObject(Settings())
}
