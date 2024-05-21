import SwiftUI

internal struct UseExtendedBINField: View {
    @Binding internal var useExtendedBIN: Bool

    internal var body: some View {
        Toggle("Use extended BIN", isOn: $useExtendedBIN)
            .padding(.bottom.union(.trailing))
    }
}

#Preview {
    UseExtendedBINField(useExtendedBIN: .constant(false))
}
