import SwiftUI

internal struct RequestView<Content: View>: View {
    internal let title: String
    internal let content: Content

    internal var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        content.padding(.bottom)
                        Spacer()
                        Divider()
                        EnvironmentView()
                    }.frame(minHeight: geometry.size.height)
                }
            }.navigationTitle(title)
                .padding()
        }.navigationViewStyle(.stack)
    }

    @inlinable
    internal init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }
}

#Preview {
    RequestView("Title") {
        VStack(alignment: .leading) {
            let previewSpacerHeight: CGFloat = 100

            Text("Some content at the beginning.").frame(
                maxWidth: /*@START_MENU_TOKEN@*/ .infinity /*@END_MENU_TOKEN@*/
            )
            Spacer().frame(height: previewSpacerHeight)
            Text("Some content at the end.")
        }
    }
    .environmentObject(Settings())
}
