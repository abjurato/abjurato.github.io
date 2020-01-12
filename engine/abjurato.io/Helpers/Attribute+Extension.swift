//
//  Attribute+Extension.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

public extension Attribute where Context == HTML.MetaContext {
    static func http_equiv() -> Attribute {
        Attribute(name: "http-equiv", value: "refresh")
    }
}
