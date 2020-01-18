//
//  Node+Extension.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 13/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Node {
    static func inline(_ nodes: Node<HTML.BodyContext>) -> Node<HTML.BodyContext> {
        .span(nodes, .class("inlinecode"))
    }
    
    static func snippet(_ nodes: Node<HTML.BodyContext>) -> Node<HTML.BodyContext> {
        .span(nodes, .class("snippet"))
    }
}
