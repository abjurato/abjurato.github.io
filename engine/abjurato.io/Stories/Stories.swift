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
