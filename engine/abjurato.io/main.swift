//
//  main.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 07/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot


struct Website {
    var index = HTML(
        .head(
            .title("My website")
        ),
        .body(
            .div(
                .h1("My website"),
                .p("Writing HTML in Swift is pretty great!")
            )
        )
    )
    
    static func render() {
        let base = URL(fileURLWithPath: CommandLine.arguments.last!, isDirectory: true)
        let website = Website()
        
        let mirror = Mirror(reflecting: website)
        
        mirror.children.compactMap{ child -> (String, String)? in
            guard let filename = child.label, let code = child.value as? HTML else { return nil }
            return (filename, code.render())
        }
        .forEach { filename, html in
            try! html.write(to: base.appendingPathComponent(filename).appendingPathExtension("html"), atomically: true, encoding: .utf8)
        }
    }
}

Website.render()

