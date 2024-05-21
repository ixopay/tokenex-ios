import SwiftUI
import TokenExMobileAPI

internal struct EnvironmentView: View {
    @EnvironmentObject internal var settings: Settings

    internal var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TokenEx ID").foregroundStyle(.secondary).font(.caption)
                Spacer()
                Text(settings.tokenExID).textSelection(.enabled)
            }
            HStack {
                Text("URL").foregroundStyle(.secondary).font(.caption)
                Spacer()
                Text(settings.mobileApiClient.apiURL.description).textSelection(.enabled)
            }
        }
    }
}

#Preview {
    EnvironmentView().environmentObject(Settings())
}
