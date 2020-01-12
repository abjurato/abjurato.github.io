//
//  main.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 07/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

struct Website: Rendarable {
    init() {
        _ = self.index
    }
    
    var filename: String = "index.html"
    
/*  do {                                         */
    let topcards: [Topcard] = Topcards.all
/*  } catch _ {                                  */
    let stories: [Story] = Stories.all
/*  mailto                                       */
    
    var general = CSS("""
    :root {
        color-scheme: light dark;
        --special-text-color: hsla(60, 100%, 50%, 0.5);
        --special-link-color: black;
        --border-color: black;
    }

    @media (prefers-color-scheme: dark) {
        :root {
            --special-text-color: hsla(60, 50%, 70%, 0.75);
            --special-link-color: white;
            --border-color: white;
        }
    }

    @import url('https://fonts.googleapis.com/css?family=Playfair+Display&display=swap');

    h1 {
        font-family: 'Playfair Display', black italic;
    }

    body {
        padding-left: 120px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
    }

    a:link, a:visited {
        color: var(--special-link-color);
        text-decoration: none;
        font-style: italic;
    }

    a:hover, a:active {
        text-decoration: underline;
    }

    .list {
        padding-left: 20px;
    }

    .comment {
        font-style: italic;
    }
    """)
    
    var cards = CSS("""
    .container {
        margin: 5px;
        width: auto;
        height: 420px;
    }

    .container > a:link {
        display: flex;
        text-decoration: none;
    }

    .item {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 30px;
        padding-left: 5px;
        width: 222px;
        height: 360px
        box-shadow: 0 0 10px rgba(0,0,0,0.3);
        border-radius: 10px;

        transition: all .1s ease-in-out;
    }

    .item:hover {
        transform: scale(1.1);
    }

    .flex {
        display: flex;
        flex-wrap: nowrap;
        overflow-y: auto;
    }

    .flex-item {
        flex: 0 0 auto;
    }
    """)
    
    lazy var index = HTML(
        .head(
            .title("(ノಠ益ಠ)ノ"),
            .stylesheet("cards.css"),
            .stylesheet("general.css"),
            .meta(.attribute(named: "viewport", value: "width=device-width"))
        ),
        .body(
            .h1("do {"),
            .p (
                .div(
                    .class("container flex"),
                    .forEach(topcards) { .card("topcards/" + $0.filename, .text($0.title), bgpath: $0.imagePath) }
                )
            ),
            
            .h1("} catch _ {"),
            .table (
                .class("list"),
                .forEach(stories) {
                    .row("stories/" + $0.filename, .text($0.date), .text($0.title)
                    )
                }
            ),
            
            .h1("}"),
            .footer(
                .div(
                    .class("comment"),
                    .a(.href("mailto:rosencrantz@protonmail.com"), .text("mailto:rosencrantz[at]protonmail.com"))
                )
            )
        )
    )
}

extension Node {
    fileprivate static func card(_ url: String, _ node: Node<HTML.BodyContext>, bgpath: String) -> Node<HTML.BodyContext> {
        .a(
            .class("link"),
            .href(url),
            .div(
                .class("item flex-item"),
                .h2(node),
                .style("color: white; background: url('\(bgpath)') center center no-repeat")
            )
        )
    }
}

extension Node {
    fileprivate static func row( _ url: String, _ date: Node<HTML.BodyContext>, _ text: Node<HTML.AnchorContext>) -> Node<HTML.TableContext> {
        .tr(
            .td(.span(date, .style("color: #D3D3D3;"))),
            .td(.span(" "), .style("display: block; width: 50px;")),
            .td(.a(.class("link"), .href(url), text))
        )
    }
}
