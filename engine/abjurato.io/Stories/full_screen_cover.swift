//
//  full_screen_cover.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 27/09/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Stories {
    static func full_screen_cover(_ base: URL, _ parent: URL) -> HTMLConstructor {
        let storyname = "fullScreenCover"
        let filename = storyname + ".html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("0.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "Back-port .fullScreenCover to SwiftUI 1.0"
        let date = "27/09/2020"
        
        return { HTML (
            .head(
                .stylesheet(generalCss.absoluteString),
                .title(title),
                .socialImageLink(image.absoluteString),
                .twitterCardType(.summary),
                .description(title),
                .url(address.absoluteString)
            ),
            .body (
                .a(.text("(lldb) thread step-out"), .href(base)), .class("comment"),
                
                .h1("\(title)"),
                .h2("Modal presentation in SwiftUI"),
                
                .p(
                    .text("SwiftUI 2.0 presented on WWDC20 brings us a lot of small improvements and additions to the APIs. In iOS 13 we already had API to open views modally in a bottom-rising sheet, but whatever the contents presentation mode was, there was no way to present it full screen."),
                    .text("Real-life example: early versions of our app had to present Camera of "), .inline("UIImagePickerController"), .text(" in such sheet which looked very stupid.")
                ),
                
                .p(
                    .text("One of the new APIs adds an ability to open views modally - "), .inline("fullScreenCover(isPresented:onDismiss:content:)"), .text("."),
                    .text("Unfortunately, this view modifier is available only on iOS 14 and higher."),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_01.png")))
                ),
                
                .p(
                    .h2("How can it be back ported to iOS 13?"),
                    .text("Short answer: with help of UIKit and thanks to its interoperability with SwiftUI."),
                    .ol(
                        .li("As one can remember, UIKit is managing view hierarchy by means of ", .inline("UIViewControllers"), .text(" which can serve as presenters to each other. In a simple cases presentation transition (animation and which part of the screen the presented controller's view will take) depends on presenting controller's "), .inline(".presentationStyle"), .text(";")),
                        .li("SwiftUI can wrap ", .inline("UIViewControllers"), .text(" into "), .inline("UIViewControllerRepresentable"), .text(" views and embed into hierarchy like any other View. Such controllers have 2 important methods ("), .inline("makeUIViewController"), .text(", "), .inline("dismantleUIViewController"), .text(") which will help us manage presentation process"))
                    ),

                    .text("So, generally the plan is:"),
                    .ol(
                        .li("Add invisible ", .inline("UIViewController"), .text(" to parent SwiftUI view")),
                        .li("Provide this controller with a child SwitUI view that needs to be presented in a full screen modal"),
                        .li("When this controller appears in the hierarchy, it will present the child using UIKit APIs"),
                        .li("When the child should be dismissed, the controller should be removed from the hierarchy")
                    ),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_02.png")))
                ),
                
                .p(
                    .text("Empowered by the beauty of "), .inline("ViewModifiers"), .text(" we can keep code almost the same!"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_03.png"))),
                    
                    .text("Production code will be more complex, but for the sake of simplicity let's omit edge cases:"),
                    
                    .ul(
                        .li("First, we'll create ModalContainerModifier which will make our API indistinguishable from native SwiftUI's one. It will embed invisible ModalContainer (UIViewControllerRepresentable) to a background when modal should be presented;"),
                        .li("In makeUIViewController we'll be wrapping SwiftUI contents-to-be-presented into UIHostingController and define presentationStyle of this child view controller - in this case .overFullScreen - which later UIKit will use for presentation. The invisible proxy will be a blank UIViewController, it's purpose is to call present(_:animated:completion) once it appears;"),
                        .li("Another important point is dismantleUIViewController - it will be called once SwiftUI removes our ModalContainer from the hierarchy. That is a correct moment to dismiss child viewController, otherwise it will never ever be removed.")
                    )
                ),
                
                .p (
                    .h2("Code"),
                    .gist(.src("https://gist.github.com/abjurato/386c32affe61eabab1ff4f5bd715ae89.js"))
                ),
                
                .br(),
                .h2("Following steps"),
                .p(.a(.href("https://swiftui-lab.com/backward-compatibility/"), .text("[1] More about approaches to backwards compatibility in SwiftUI"))),
                .p(.a(.href("https://coderwall.com/p/dgdgeq/how-to-re-sign-ios-builds"), .text("[2] How to re-sign iOS builds"))),
                
                .br(),
                .div(.text(date), .class("comment"))
            )
        ) }
    }
}
