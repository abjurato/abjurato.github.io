import SwiftUI

struct FullScreenCoverExample: View {
    @State var isPresenting: Bool = true
    
    var body: some View {
        Button("Presenter") {
            isPresenting.toggle()
        }
        .fullScreenCover(isPresented: $isPresenting) {
            Color.purple.ignoresSafeArea()
        }
    }
}

struct FullScreenCover_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverExample().previewDisplayName(".fullScreenCover")
    }
}
