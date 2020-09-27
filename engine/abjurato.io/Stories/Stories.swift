//
//  Stories.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 27/09/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

enum Stories {
    static func all(base: URL, parent: URL) -> [Story] {[
        Story(filename: "fullScreenCover.html", date: "27/09/2020", title: "Back-port .fullScreenCover to SwiftUI 1.0", constructor: self.full_screen_cover(base, parent))
    ]}
}

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
                
                .p(.text("SwiftUI 2.0 presented on WWDC20 brings us a lot of small improvements and additions to the APIs. In iOS 13 we already had API to open views modally in a bottom-rising sheet, but whatever the contents presentation mode was, there was no way to present it full screen.")),
                .p(.text("Real-life example: early versions of our app had to present Camera of "), .inline("UIImagePickerController"), .text(" in such sheet which looked very stupid.")),
                
                .p(.text("One of the new APIs adds an ability to open views modally - "), .inline("fullScreenCover(isPresented:onDismiss:content:):")),
                .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_01.png"))),
                .p(.text("Unfortunately, this view modifier is available only on iOS 14 and higher. ")),
                
                .h2("How can it be back ported to iOS 13?"),
                
                .p(
                    .text("Short answer: with help of UIKit and thanks to its interoperability with SwiftUI. "),
                    .ol(
                        .li("As one can remember, UIKit is managing view hierarchy by means of ", .inline("UIViewControllers"), .text(" which can serve as presenters to each other. In a simple cases presentation transition (animation and which part of the screen the presented controller’s view will take) depends on presenting controller’s "), .inline(".presentationMode"), .text(";")),
                        .li("SwiftUI can wrap ", .inline("UIViewControllers"), .text(" into "), .inline("UIViewControllerRepresentable"), .text(" views and embed into hierarchy like any other View. Such controllers have 2 important methods ("), .inline("makeUIViewController"), .text(", "), .inline("dismantleUIViewController"), .text(") which will help us manage presentation process"))
                    )
                ),
                
                .p(
                    .text("So, generally the plan is:"),
                    .ol(
                        .li("1. Add invisible ", .inline("UIViewController"), .text(" to parent SwiftUI view")),
                        .li("2. Provide this controller with a child SwitUI view that needs to be presented in a full screen modal"),
                        .li("3. When this controller appears in the hierarchy, it will present the child using UIKit APIs"),
                        .li("4. When the child should be dismissed, the controller should be removed from the hierarchy")
                    ),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_02.png")))
                ),
                
                .p("Production code will be more complex, but for the sake of simplicity let’s omit edge cases:"),
                .gist(.src("https://gist.github.com/abjurato/386c32affe61eabab1ff4f5bd715ae89.js")),
                
                .p(
                    .text("And empowered by the beauty of "), .inline("ViewModifiers"), .text(" we can keep code almost the same! More about approaches to backwards compatibility in SwiftUI: https://swiftui-lab.com/backward-compatibility/")
                ),
                
                .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_03.png"))),
                
                .br(),
                .div(.text(date), .class("comment"))
            )
        ) }
    }
}
