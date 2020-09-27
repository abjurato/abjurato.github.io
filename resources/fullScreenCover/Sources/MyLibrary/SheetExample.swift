import SwiftUI

struct SheetExample: View {
    @State var isPresenting: Bool = true
    
    var body: some View {
        Button("Presenter") {
            isPresenting.toggle()
        }
        .sheet(isPresented: $isPresenting) {
            Color.purple.ignoresSafeArea()
        }
    }
}

struct SheetExample_Previews: PreviewProvider {
    static var previews: some View {
        SheetExample().previewDisplayName(".sheet")
    }
}
