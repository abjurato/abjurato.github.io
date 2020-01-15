//
//  Topcards.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation

enum Topcards {
    static func all(base: URL, parent: URL) -> [Topcard] {
        [
            self.re_sign_binary(base: base, parent: parent),
            decrypt_binary(base: base, parent: parent)
        ]
//        Topcard(filename: "", date: "", title: "find resources of an app (on jailbroken device)", imagePath: "images/4.jpeg"),
//        Topcard(filename: "", date: "", title: "lib injection (on jailbroken device)", imagePath: "images/5.jpeg"),
//        Topcard(filename: "", date: "", title: "Untitled 6", imagePath: "images/6.jpeg")
    }
}

        
