//
//  dump-keychain-ios11-electra.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 13/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Topcards {
    static func decrypt_binary(base: URL, parent: URL) -> Topcard {
        let filename = "decrypt_binary.html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("2.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "decrypt iOS app (from jailbroken device memory)"
        
        return Topcard(filename: filename,
                date: "",
                title: title,
                imagePath: image) {
            HTML(
                .head(
                    .stylesheet(generalCss.absoluteString),
                    .title(title),
                    .socialImageLink(image.absoluteString),
                    .twitterCardType(.summary),
                    .description(title),
                    .url(address.absoluteString)
                ),
                .body(
                    .h1("Decrypt iOS app (from jailbroken device memory)"),
                    
                    .h2("Manually"),
                    .p(.text("In this part we'll be moving straightforward: when app is launched, binary is decrypted and loaded memory. We will read the according blob from memory, write to a file, transfer that file to mac, replace encrypted section of Mach-O file with this blob and edit load commands so "), .inline("launchd"), .text(" will not consider this binary encrypted. That will not allow running the binary from sandboxed directories, you will need to re-sign the binary with your own sign identity or sideload the app to the device in some other way. Decrypted binary may be inspected in disassembler or other tools.")),
                        
                    .p(
                        .h3("Prepare encrypted binary"),
                        .text("You will need "), .inline("otool"), .text(" and "), .inline("scp"), .text(" utilities on macOS side"),
                        .ul(
                            .li(.text("[iOS side] run the app and detect path to the executable:"),
                                .snippet("# ps ax | grep NAME")),
                            .li(.text("[macOS side] pull the file from iOS device to your mac:"),
                                .snippet("$ scp root@<IP>:<IOS-PATH> <MAC-PATH>")),
                            .li(.text("[macOS side] find details of encrypted section in load commands:"),
                                .snippet("$ otool -l <MAC-PATH> | grep crypt"),
                                .text("that will give output similar to this one:"),
                                .script(.src("https://gist.github.com/abjurato/d02aa3d04cef70c78e408ab76030e90a.js"))
                                )
                        )
                    ),
                    
                    .p(
                        .h3("Attach debugger to iOS app"),
                        .text("You will need "), .inline("debugserver"), .text(" on iOS side, "), .inline("lldb"), .text(" and "), .inline("MachOView"), .text(" on macOS side"),
                        .ul (
                            .li(.text("[iOS side] run the app tell debugserver to attech to it and wait for debugger on some port"),
                                .snippet("# debugserver *:<PORT> -a <NAME>")),
                            .li(.text("[macOS side] Run lldb, connect to port exposed by debugserver from iOS:"),
                                .script(.src("https://gist.github.com/abjurato/21f676fa5c7ba85d5bccf824e5f806b1.js"))),
                            .li(.text("[macOS side] Inject dump into encrypted binary you've obtained earlier"),
                                .snippet("$ dd seek=<cryptoff> bs=1 conv=notrunc if=<DUMP> of=<BINARY>")),
                            .li(.text("Disable load command managing decryption of encrypted section in the patched binary:"),
                                .ul(
                                    .li(.text("open binary in MachOView")),
                                    .li(.inline("Load Commands"), .text(" > "), .inline("LC_ENCRYPTION_INFO_64")),
                                    .li("for CryptID line set Data to 0")
                                ))
                        )
                    ),
                    
                    .h2("Frida"),
                    .p(
                        .text("There were many automated alternatives for this task: Clutch, bfinject, etc. As of iOS 12 this task can be most comfortably automated using Frida (once you'll figure out how to properly configure it). You will need "), .inline("iTunnel"), .text(" and "), .inline("Frida"), .text(" and Frida plugin called "), .inline("frida-ios-dump"), .text("."),
                        .ul(
                            .li(.text("[macOS side] run iTunnel to forward SSH traffic to USB"),
                                .snippet("$ itnl --lport 2222 --iport 22")),
                            .li(.text("[macOS side] run properly configured script from plugin directory to find identifier of app you need:"),
                                .snippet("$ ./dump.py -l")),
                            .li(.text("[macOS side] run properly configured script from plugin directory to dump the app, full ipa bundle will be created on your mac:"),
                                .snippet("$ ./dump.py <IDENTIFIER>"))
                        )
                    ),
                    
                    .br(),
                    .h2("Sources"),
                    .p(.a(.href("https://github.com/ivRodriguezCA/RE-iOS-Apps/blob/master/Module-2/README.md"), .text("[1] Reverse Engineering iOS Applications by Ivan Rodriguez")))
                )
            )
        }
    }
}
