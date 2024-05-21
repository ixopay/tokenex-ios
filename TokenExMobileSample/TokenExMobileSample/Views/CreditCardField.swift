import SwiftUI

internal struct CreditCardField: View {
    @Binding internal var pan: String

    internal var body: some View {
        LabeledContent("Credit card number") {
            TextField("1234 5678 9012 3456", text: $pan) { UIApplication.shared.endEditing() }
                .keyboardType(.numberPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                            },
                            label: {
                                Text("Done")
                            }
                        )
                    }
                }
        }
    }
}

#Preview {
    CreditCardField(pan: .constant(""))
}
