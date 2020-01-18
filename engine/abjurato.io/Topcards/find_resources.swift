//
//  find_resources.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 18/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Topcards {
    static func find_resources(base: URL, parent: URL) -> Topcard {
        let filename = "find_resources.html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("3.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "find resources of an app (on jailbroken device)"
        let date = "Jan 2020, iOS 12.4"
        
        return Topcard(filename: filename,
                date: date,
                title: title,
                imagePath: image) {
            HTML(
                .lang(.english),
                .head(
                    .stylesheet("../general.css"),//generalCss.absoluteString),
                    .title(title),
                    .socialImageLink(image.absoluteString),
                    .twitterCardType(.summary),
                    .description(title),
                    .url(address.absoluteString)
                ),
                .body(
                    .a(.text("(lldb) thread step-out"), .href(base), .class("comment")),
                    
                    .h1("Find resources of an app (on jailbroken device)"),

                    .p(
                        .text("An app from AppStore has following places where its stuff can be found:"),
                        .ol(
                            .li("App bundle with executable, resources and extensions", .snippet("/var/containers/Bundle/Application")),
                            .li("App working directory", .snippet("/var/mobile/Containers/Data/Application")),
                            .li("App Extensions working directory", .snippet("/var/mobile/Containers/Data/PluginKitPlugin")),
                            .li("App Groups working directory", .snippet("/var/mobile/Containers/Shared/AppGroup"))
                        ),
                        .text("First one is signed by developer during upload to AppStore, so no one can modify it's contents without re-signing the binary (or breaking codesisning validations). The others are directories for data generated during app lifetime. Each of the directories above has and UUID-named subfolders, where UUID is randomly generated during app installation."),
                        .br(),
                        .text("How does the system know which directory belongs to which app then? System service called "), .inline("LaunchServices"), .text("does.")
                    ),
                    
                    .h2("Caveman methods (1, 2, 3, 4)"),
                    .p(
                        .p (
                            .text("Easiest way - run process explorer "), .inline("# ps ax | grep <NAME>"), .text(" on iOS side while the app in interest is launched, which will show binary's localtion per process - whether the process is one of app or of app extension.")
                        ),
                        .p (
                            .text("List of app groups the app participates in can be found by reading binary's entitlements:"),
                            .snippet("# ldid -e <PATH-TO-BINARY>")
                        ),
                        .p(
                            .text("Each of UUID'd folders contains hidden "), .inline(".com.apple.mobile_container_manager.metadata.plist"), .text(" file which contains either bundle ID or app group ID in "), .inline("MCMMetadataIdentifier"), .text(" field. So a brave reader can enumerate 1-4 directories and every one of subfolders in them, and search for those with bundleID/appGroupID of interest in the hidden plist.")
                        ),
                        .p(
                            .text("Another way for desperate researcher would be to look for LaunchServices database located in a temporary folder under one of "), .inline("/private/var/containers/Data/System"), .text(" subfolders with a filename similar to "), .inline("com.apple.LaunchServices-231-v2.csstore"), .text(". Altho I did not find any way to conveniently read contents of that file apart from running "), .inline("LSDTrip"), .text(" which is capable of talking to a responsible "), .inline("lsd"), .text(" launch services daemon on device itself.")
                        )
                    ),
                    
                    .h2("Objection and Frida (1, 2)"),
                    .p (
                        .text("Task is fully automated by "), .inline("objection"), .text(" framerwork for "), .inline("Frida"), .text(":"),
                        .ul(
                            .li(.text("Connect to "), .inline("Frida"), .text(" server on device:"),
                                .snippet("$ itnl --lport 2222 --iport 22")),
                            .li(.text("Connect "), .inline("objection"), .text(" to the app by correct name:"),
                                .snippet("$ objection --gadget=\"Telegram\" explore")),
                            .li(.text("Command "), .inline("env"), .text(" will output the directories:"),
                                .gist(.src("https://gist.github.com/abjurato/1553ca7fa811570a0592892a10090fec.js")))
                        )
                    ),
                    
                    .h2("LSDTrip (1, 2, 3, 4)"),
                    .p (
                        .text("Utility called "), .inline("LSDTrip") ,.text(" by Jonathan Levin gives more complete output. It is open source, but installation instructions in [2] are a little bit outdated - as of iOS 12 entitlements should be as follows:"),
                        .gist(.src("https://gist.github.com/abjurato/78f2e6b85a475317f04bfd966367c6f8.js")),
                        .text("and a little bit verbose output of "), .inline("# ./lsdtrip.arm64 dump"), .text(" will contain "), .inline("appContainer"), .text(", "), .inline("dataContainer"), .text(", "), .inline("groups"),
                        .gist(.src("https://gist.github.com/abjurato/1f8a85aa0f148f2db3bc24cb7d9b2738.js")),
                        .text(" and a list of "), .inline("plugin Identif"), .text("iers, each of which has it's own place in the output down below:"),
                        .gist(.src("https://gist.github.com/abjurato/4c819634786f4d41b5edb63df1ee22e4.js"))
                    ),
                    
                    .br(),
                    .h2("Sources"),
                    .p(.a(.href("https://mobile-security.gitbook.io/mobile-security-testing-guide/ios-testing-guide/0x06b-basic-security-testing#using-objection"), .text("[1] OWASP Mobile Security Testing Guide"))),
                    .p(.a(.href("http://newosxbook.com/tools/lsdtrip.html"), .text("[2] LSDTrip - Take a ride down the LaunchServices.framework rabbithole"))),
                    
                    .br(),
                    .div(.text(date), .class("comment"))
                )
            )
        }
    }
}
