import SwiftUI
import TokenExMobileAPI

internal struct TokenSchemePicker: View {
    @Binding internal var tokenScheme: TXTokenScheme

    internal var body: some View {
        HStack {
            Text("Token scheme")
            Spacer()
            Picker("Token scheme", selection: $tokenScheme) {
                ForEach(TXTokenScheme.allCases, id: \.self) { tokenScheme in
                    Text(tokenScheme.description)
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var tokenScheme = TXTokenScheme.sixTOKENfour
        var body: some View {
            TokenSchemePicker(tokenScheme: $tokenScheme)
        }
    }

    return Preview()
}
