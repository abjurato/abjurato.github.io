import SwiftUI
import UIKit

extension View {
    func fullScreenCoverBackport<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        ModifiedContent(content: self, modifier: ModalContainerModifier(isPresented: isPresented, addition: content()))
    }
}

struct ModalContainerModifier<Addition: View>: ViewModifier {
    @Binding var isPresented: Bool
    var addition: Addition
    
    func body(content: Content) -> some View {
        content
        .background( ZStack {
            if isPresented {
                ModalContainer(presentationStyle: .overFullScreen, content: addition)
            }
        })
    }
}

struct ModalContainer<Content: View>: UIViewControllerRepresentable {
    var presentationStyle: UIModalPresentationStyle?
    let content: Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ModalContainer>) -> UIViewController {
        let proxyController = ViewController()
        proxyController.child = UIHostingController(rootView: content)
        proxyController.presentationStyle = self.presentationStyle
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // nothing is needed here
    }

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        (uiViewController as! ViewController).child?.dismiss(animated: true, completion: nil)
    }
    
    private class ViewController: UIViewController {
        var presentationStyle: UIModalPresentationStyle?
        var child: UIHostingController<Content>?
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            child?.modalPresentationStyle = self.presentationStyle ?? .automatic
            
            if let child = child {
                self.present(child, animated: true, completion: nil)
            }
        }
    }
}
