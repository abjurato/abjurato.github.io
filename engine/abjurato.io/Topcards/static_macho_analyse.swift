//
//  static_macho-analyse.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 19/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Topcards {
    static func static_macho_analyse(base: URL, parent: URL) -> Topcard {
        let filename = "static_macho_analyse.html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("4.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "static Mach-O binary analyse"
        let date = "Jan 2020"
        
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
                    
                    .h1("Static Mach-O binary analyse"),

                    .h2("macOS side"),
                    .p(
                        .ul(
                            .li(.inline("$ file <BINARY>"), .text(" - will tell the type of file")),
                            .li(.inline("$ codesign -dv <BINARY>"), .text(" - verify code signature")),
                            .li(.inline("$ codesign -d --entitlements - <BINARY>"), .text(" - defalut way to get entitlements")),
                            .li(.inline("$ ./jtool2 --ent <BINARY>"), .text(" - another way to get entitlements")),
                            .li(.inline("$ pagestuff <BINARY> -a"), .text(" - sections and segments in Mach-O")),
                            .li(.inline("$ nm -m <BINARY>"), .text(" - another way to get some info from sections and segments")),
                            .li(.inline("$ otool -L <BINARY>"), .text(" - dylibs that binary links to")),
                            .li(.inline("$ otool -l <BINARY>"), .text(" - all load commands")),
                            .li(.inline("$ otool -l <BINARY> | grep crypt"), .text(" - information about encrypted blob")),
                            .li(.inline("$ ./jtool2 -e <SECTION>.<SEGMENT> <BINARY>"), .text(" - extract section/segment into separate file")),
                            .li(.inline("$ strings - <BINARY>"), .text(" - all C stirngs")),
                            .li(.inline("$ ./class-dump -H -o <DIRECTORY-OUT> <BINARY>"), .text(" - dump objc classes headers"))
                        )
                    ),
                    
                    .h2("iOS side"),
                    .h3("binary"),
                    .p(
                        .ul(
                            .li(.inline("# ldid -e <BINARY>"), .text(" - read entitlements of binary")),
                            .li(.text("+ all "), .inline("jtool2"), .text(" related from macOS section"))
                        )
                    ),
                    
                    .h3("resources"),
                    .p(
                        .ul (
                            .li(.inline("# ./FileDP -f/d <FILE/DIRECTORY>"), .text(" - read Data Protection class of file/directory"))
                        )
                    ),
                    
                    .br(),
                    .h2("Sources"),
                    .p(.a(.href("http://newosxbook.com/tools/jtool.html"), .text("[1] jtool - Taking the O out of otool(1), and so much more by Jonathan Levin"))),
                    .p(.a(.href("https://go.sentinelone.com/ebook-macos-reversing-malware-registration.html"), .text("[2] How to reverse malware on macOS without getting infected by Phil Stokes"))),
                    .p(.a(.href("https://github.com/abjurato/FileDp-Source"), .text("[3] my fork of FileDP by @satishb3 sutable for iOS 12.4"))),
                    .p(.a(.href("https://github.com/nygard/class-dump"), .text("[4] class-dump sources, you will need to rebuild them for 64bit to run on macOS Catalina"))),
                       
                    .br(),
                    .div(.text(date), .class("comment"))
                )
            )
        }
    }
}
