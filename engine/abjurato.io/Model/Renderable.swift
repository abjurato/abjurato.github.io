//
//  Renderable.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

protocol Rendarable {
    var filename: String { get }
    func render(base: URL)
}

extension Array: Rendarable where Element: Rendarable {
    var filename: String { "" }
    func render(base: URL) {
        forEach {
            $0.render(base: base)
        }
    }
}

extension Rendarable {
    func render(base: URL) {
        
        func renderChildren(_ mirror: Mirror?) {
            mirror?.children.forEach { child in
                if let filename = child.label, let subpage = child.value as? Rendarable {
                    let subbase = base.appendingPathComponent(filename)
                    try? FileManager.default.createDirectory(at: subbase, withIntermediateDirectories: false, attributes: nil)
                    subpage.render(base: subbase)
                }
                if let filename = self.filename.isEmpty ? child.label : self.filename, let code = child.value as? HTML {
                    try! code.render().write(to: base.appendingPathComponent(filename),
                                             atomically: true,
                                             encoding: .utf8)
                }
                if let filename = child.label, let code = child.value as? CSS {
                    try! code.render().write(to: base.appendingPathComponent(filename).appendingPathExtension("css"),
                                             atomically: true,
                                             encoding: .utf8)
                }
            }
        }
        
        let mirror = Mirror(reflecting: self)
        renderChildren(mirror.superclassMirror)
        renderChildren(mirror)
        
    }
}
