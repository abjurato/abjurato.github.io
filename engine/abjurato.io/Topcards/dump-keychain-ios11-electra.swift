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
    static func dump_keychain_ios11_electra() -> Topcard {
        Topcard(filename: #function.removingBrackets() + ".html",
                date: "",
                title: "dump keychain on iOS 11 with Electra",
                imagePath: "images/1.jpeg") {
            HTML(
                .head(
                    .stylesheet("../general.css")
                ),
                .body(
                    .h1(
                        .text("hello")
                    )
                )
            )
        }
    }
}
