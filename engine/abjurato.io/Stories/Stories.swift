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
        Story(filename: "kindleEbooks.html", date: "11/10/2020", title: "Amazon Kindle: iOS App Reverse Engineering for eBooks Leaking", constructor: self.kindle_ebooks(base, parent)),
        Story(filename: "alpinaEbooks.html", date: "04/10/2020", title: "Alpina.Books: iOS App Forensics for eBooks Smuggling", constructor: self.alpina_ebooks(base, parent)),
        Story(filename: "fullScreenCover.html", date: "27/09/2020", title: "Back-port .fullScreenCover to SwiftUI 1.0", constructor: self.full_screen_cover(base, parent))
    ]}
}
