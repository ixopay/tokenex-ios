import SwiftUI

internal struct ProcessingView: View {
    internal var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    ProcessingView()
}
