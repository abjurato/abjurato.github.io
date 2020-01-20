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
            self.decrypt_binary(base: base, parent: parent),
            self.find_resources(base: base, parent: parent),
            self.static_macho_analyse(base: base, parent: parent)
        ]
//        Topcard(filename: "", date: "", title: "lib injection (on jailbroken device)", imagePath: "images/5.jpeg")
    }
}

        
