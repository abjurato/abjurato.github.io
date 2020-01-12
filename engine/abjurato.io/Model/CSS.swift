//
//  CSS.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation

struct CSS {
    var code: String
    func render() -> String { return self.code }
    init(_ code: String) { self.code = code }
}
