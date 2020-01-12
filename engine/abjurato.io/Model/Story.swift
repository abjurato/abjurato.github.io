//
//  Story.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

typealias HTMLConstructor = ()->HTML

class Story: Rendarable {
    var filename: String
    var external: String?
    let date: String
    let title: String
    let page: HTML
    
    init(filename: String, date: String, title: String, constructor: HTMLConstructor? = nil) {
        self.filename = filename
        self.date = date
        self.title = title
        
        self.page = constructor?() ?? HTML(
            .body(
                .h1("404")
            )
        )
    }
    
    init(external: String, date: String, title: String) {
        self.filename = external.filenameCharacters() + ".html"
        self.date = date
        self.title = title
        
        self.page = HTML(
            .head(
                .meta(
                    .content("0; url='\(external)'"),
                    .http_equiv()
                )
            ),
            .body(
                .text("redirecting...")
            )
        )
    }
    
    var story = CSS("""
    :root {
        color-scheme: light dark;
        --special-text-color: hsla(60, 100%, 50%, 0.5);
        --border-color: black;
    }

    body {
        padding-left: 120px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
    }
    """)
}
