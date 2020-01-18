//
//  dump-keychain-ios11-electra.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Topcards {
    static func re_sign_binary(base: URL, parent: URL) -> Topcard {
        let filename = "re_sign_binary.html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("1.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "re-sign decrypted binary (with Apple Developer account)"
        let date = "Jan 2020, iOS 12.4"
        
        return Topcard(filename: filename,
                date: date,
                title: title,
                imagePath: image) {
            HTML(
                .lang(.english),
                .head(
                    .stylesheet(generalCss.absoluteString),
                    .title(title),
                    .socialImageLink(image.absoluteString),
                    .twitterCardType(.summary),
                    .description(title),
                    .url(address.absoluteString)
                ),
                .body(
                    .a(.text("(lldb) thread step-out"), .href(base), .class("comment")),
                    
                    .h1("Re-sign binary (with Apple Developer account)"),
                    .h2("macOS side"),
                    .p(
                        .ol(
                            .li(.text("Rename your decrypted "), .inline("<NAME>.ipa"), .text(" into "), .inline("<NAME>.zip"), .text(", unarchive, open")),
                            .li(.text("Change bundleId in "), .inline("Payload/<NAME>.app/Info.plist"), .text(" to something matching your Apple Developer account")),
                            .li(
                                .text("Minimal "), .inline("<whatever>.entitlements"), .text(" should have following info:"),
                                .script(.src("https://gist.github.com/abjurato/ce9afee76e783ebb6b767785635d31d1.js"))
                            ),
                            .li(.text("Create app with same bundle id and all the additional capabilities you've included in entitlements xml on "), .a(.href("https://developer.apple.com/account/ios/identifier/bundle"), .text("Apple Developer website"))),
                            .li(.text("Create provisioning profile for your app id, your device, your developer account on "), .a(.href("https://developer.apple.com/account/ios/profile/production"), .text("Apple Developer website")), .text(", download it and rename to "), .inline("embedded.mobileprovision")),
                            .li(
                                .text("Check that you have correct signing identity and re-sign the binary"),
                                .script(.src("https://gist.github.com/abjurato/5767d2195912756433b08fa958aa4ac9.js"))
                            ),
                            .li(
                                .text("Pack new ipa with this binary:"),
                                .snippet("$ zip -qr <NAME2>.ipa Payload/")
                            )
                        )
                    ),
                    
                    .h2("iOS side"),
                    .p(
                        .text("On a jaibroken device you can modify entitlements and simulate codesigning using ldid utility"),
                        .script(.src("https://gist.github.com/abjurato/202b53df3e7184210368045f57a043ee.js"))
                    ),
                    
                    .br(),
                    .h2("Sources"),
                    .p(.a(.href("https://www.objc.io/issues/17-security/inside-code-signing/"), .text("[1] Theory about codesigning"))),
                    .p(.a(.href("https://coderwall.com/p/dgdgeq/how-to-re-sign-ios-builds"), .text("[2] How to re-sign iOS builds"))),
                    .p(.a(.href("https://www.vantagepoint.sg/blog/85-patching-and-re-signing-ios-apps"), .text("[3] Patching and Re-Signing iOS Apps"))),
                    
                    .br(),
                    .div(.text(date), .class("comment"))
                )
            )
        }
    }
}
