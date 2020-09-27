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

public extension Node where Context: HTMLScriptableContext {
    static func gist(_ nodes: Node<HTML.ScriptContext>...) -> Node<HTML.BodyContext> {
        .div(.element(named: "script", nodes: nodes), .class("gist"))
    }
    
    static func screenshot(_ src: Attribute<HTML.ImageContext>) -> Node<HTML.BodyContext> {
        .div(.img(src), .class("screenshot"))
    }
}
