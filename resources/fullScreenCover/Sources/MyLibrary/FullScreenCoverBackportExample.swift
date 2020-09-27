import SwiftUI

struct FullScreenCoverBackportExample: View {
    @State var isPresenting: Bool = true
    
    var body: some View {
        Button("Presenter") {
            isPresenting.toggle()
        }
        .fullScreenCoverBackport(isPresented: $isPresenting) {
            Color.purple.ignoresSafeArea()
        }
    }
}

struct FullScreenCoverBackport_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverBackportExample().previewDisplayName(".fullScreenCoverBackport")
    }
}
