import SwiftUI

internal struct CVVField: View {
    @Binding internal var cvv: String

    internal var body: some View {
        LabeledContent("CVV") {
            TextField("123", text: $cvv) { UIApplication.shared.endEditing() }
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
    CVVField(cvv: .constant(""))
}
