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
    let base: URL
    init(base: URL) {
        self.base = base
        _ = self.index
        _ = self.topcards
        _ = self.stories
    }
    
    var filename: String = "index.html"
    
/*  do {                                         */
    let topcards: [Topcard] = Topcards.all(base: URL(string: "https://abjurato.github.io/")!, parent: URL(string: "https://abjurato.github.io/topcards")!)
/*  } catch _ {                                  */
    let externals: [External] = Externals.all
    let stories: [Story] = Stories.all(base: URL(string: "https://abjurato.github.io/")!, parent: URL(string: "https://abjurato.github.io/stories")!)
/*  mailto                                       */
    
    var general = CSS("""
    :root {
        color-scheme: light dark;
        --special-text-color: hsla(60, 100%, 50%, 0.5);
        --special-link-color: black;
        --border-color: black;
        --special-background: #d7d7d7;

        --special-max-width: 90%;
        --special-left-padding: 120px;

        --item-background: #ebebeb;
        --item-box-shadow-top: #a5a5a5;
        --item-box-shadow-bottom:  #ffffff;
    }

    @media (prefers-color-scheme: dark) {
        :root {
            --special-text-color: hsla(60, 50%, 70%, 0.75);
            --special-link-color: white;
            --border-color: white;
            --special-background: #222222;

            --item-background: #222222;
            --item-box-shadow-top: #181818;
            --item-box-shadow-bottom:  #2c2c2c;
        }
    }

    @media only screen and (max-width: 600px) {
      :root {
        --special-left-padding: 10px;
        --special-max-width: 100%;
      }
    }

    @font-face {
        font-family: JetBrainsMono;
        src: url("fonts/JetBrainsMono-Regular.ttf");
        font-style: normal;
    }
    @font-face {
        font-family: JetBrainsMono;
        src: url("fonts/JetBrainsMono-Italic.ttf");
        font-style: italic;
    }
    @font-face {
        font-family: JetBrainsMono;
        src: url("fonts/JetBrainsMono-Bold-Italic.ttf");
        font-style: italic;
        font-weight: bold;
    }

    h1 {
        font-size: 3em;
    }

    body {
        max-width: 80%;
        background-color: var(--special-background);
        padding-left: var(--special-left-padding);
        font-family: "JetBrainsMono", -apple-system, Roboto, Helvetica, sans-serif;
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

    td {
        vertical-align: baseline;
        padding: 5px;
    }

    .comment {
        font-style: regular;
        font-size: 0.7em;
    }

    .inlinecode {
        background: #f4f4f4;
        color: #666;
        page-break-inside: avoid;
        font-family: monospace;
        font-size: 11px;
        line-height: 10px;
        overflow: auto;
        padding: 0.1em 0.5em;
        display: inline-block;
        word-wrap: break-word;
        border-radius: 0.1em;
    }

    .snippet {
        background: #f4f4f4;
        border: 1px solid #ddd;
        color: #666;
        page-break-inside: avoid;
        font-family: monospace;
        font-size: 11px;
        line-height: 10px;
        margin-bottom: 1.6em;
        max-width: var(--special-max-width);
        overflow: auto;
        padding: 0.5em 0.5em;
        display: block;
        word-wrap: break-word;
        border-radius: 0.2em;
    }

    .gist {
        max-width: var(--special-max-width);
    }

    .screenshot {
        max-width: var(--special-max-width);
        max-height: var(--special-max-width);
        padding: 15px 15px 15px 15px;
    }

    img {
      display: block;
      width: 80%;
      height: auto;
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
        height: 360px;

        border-radius: 10px;

        
        background: var(--item-background);
        box-shadow: 8px 8px 13px var(--item-box-shadow-top),
                    -8px -8px 13px var(--item-box-shadow-bottom);

        box-shadow: 8px 8px 13px var(--item-box-shadow-top),
                    -8px -8px 13px var(--item-box-shadow-bottom);

        transition: all .1s ease-in-out;
    }

    .item:hover {
        transform: scale(1.02);
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
        .lang(.english),
        .head(
            .title("(ノಠ益ಠ)ノ"),
            .stylesheet("cards.css"),
            .stylesheet("general.css"),
            .viewport(.accordingToDevice, initialScale: 1),
                
            .socialImageLink(self.base.appendingPathComponent("images").appendingPathComponent("0.jpeg")),
            .twitterCardType(.summary),
            .description("Notes on iOS development and reverse engineering"),
            .url(self.base.absoluteString)
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
                    .row("stories/" + $0.filename, .text($0.date), .text($0.title))
                },
                
                .forEach(externals) {
                    .row($0.external, .text($0.date), .text($0.title) )
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
            .td(.span(date, .style("color: #D3D3D3;"), .class("comment"))),
            .td(.span(" "), .style("display: block; width: 5px;")),
            .td(.a(.class("link"), .href(url), text))
        )
    }
}
