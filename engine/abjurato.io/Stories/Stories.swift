//
//  Stories.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

enum Stories {
    static var all: [Story] = [
        Story(external: "https://medium.com/@abjurato/iterating-over-swiftui-views-delivered-in-a-swift-package-a6ffb98132ce",
              date: "23/06/2019",
              title: "Iterating over SwiftUI views delivered in a Swift Package"),
        
        Story(filename: "24-03-2018.html", date: "24/03/2018", title: "24/7 Accelerometer Tracking with Apple Watch") {
            HTML (
                .head(
                    .stylesheet("../general.css")
                ),
                .body (
                    .h1("So empty"),
                    .h2("much unemplemented")
                )
            )
        },
        Story(filename: "16-03-2018.html", date: "16/03/2018", title: "Using Raspberry Pi as an Apple TimeMachine"),
        Story(filename: "09-07-2017.html", date: "09/07/2017", title: "Adaptive Design in iOS"),
        Story(filename: "15-03-2017.html", date: "15/03/2017", title: "OWASP for iOS: M1 - Improper Platform usage, Part 2"),
        Story(filename: "29-01-2017.html", date: "29/01/2017", title: "Unified Logging and Activity Tracing"),
        Story(filename: "24-12-2016.html", date: "24/12/2016", title: "OWASP for iOS: M1 - Improper Platform usage, Part 1"),
        Story(filename: "04-05-2016.html", date: "04/05/2016", title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 4"),
        Story(filename: "03-05-2016.html", date: "03/05/2016", title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 3"),
        Story(filename: "01-05-2016.html", date: "01/05/2016", title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 2"),
        Story(filename: "30-04-2016.html", date: "30/04/2016", title: "Swift, Perfect, mustache and PostgreSQL on Heroku")
    ]
}
