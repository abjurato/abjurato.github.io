//
//  Stories.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

enum Externals {
    static var all: [External] = [
        // ProtonMail Blog
        External(external: "https://protonmail.com/blog/ios-security-model/",
                  date: "30/10/2019",
                  title: "[co-author] ProtonMail iOS client security"),
        External(external: "https://protonmail.com/blog/ios-security-recommendations/",
                 date: "30/10/2019",
                 title: "[co-author] Security recommendation: enable FaceID or PIN protection on the ProtonMail iOS app"),
        
        // Medium
        External(external: "https://medium.com/@abjurato/iterating-over-swiftui-views-delivered-in-a-swift-package-a6ffb98132ce",
                 date: "23/07/2019",
                 title: "Iterating over SwiftUI views delivered in a Swift Package"),
        External(external: "https://medium.com/@abjurato/24-7-accelerometer-tracking-with-apple-watch-3dab2eb68f23",
                 date: "24/03/2018",
                 title: "24/7 Accelerometer Tracking with Apple Watch"),
        External(external: "https://medium.com/@abjurato/using-raspberry-pi-as-an-apple-timemachine-d2fceecb6876",
                 date: "16/03/2018",
                 title: "Using Raspberry Pi as an Apple TimeMachine"),
        External(external: "https://medium.com/@abjurato/adaptive-design-in-ios-9c784d630494",
                 date: "09/07/2017",
                 title: "Adaptive Design in iOS"),
        External(external: "https://medium.com/@abjurato/m1-improper-platform-usage-part-2-5716ee1492e",
                 date: "15/03/2017",
                 title: "OWASP for iOS: M1 - Improper Platform usage, Part 2"),
        External(external: "https://medium.com/@abjurato/unified-logging-and-activity-tracing-aa77ffe9fb53",
                 date: "29/01/2017",
                 title: "Unified Logging and Activity Tracing"),
        External(external: "https://medium.com/@abjurato/owasp-for-ios-m1-improper-platform-usage-part-1-7aff742c50ee",
                 date: "24/12/2016",
                 title: "OWASP for iOS: M1 - Improper Platform usage, Part 1"),
        External(external: "https://medium.com/@abjurato/swift-perfect-mustache-and-postgresql-on-heroku-4-9f4ea43c9529",
                 date: "04/05/2016",
                 title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 4"),
        External(external: "https://medium.com/@abjurato/swift-perfect-mustache-and-postgresql-on-heroku-3-e5c1f0982e0b",
                 date: "03/05/2016",
                 title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 3"),
        External(external: "https://medium.com/@abjurato/swift-perfect-mustache-and-postgresql-on-heroku-2-415bd1a0e930",
                 date: "01/05/2016",
                 title: "Swift, Perfect, mustache and PostgreSQL on Heroku - 2"),
        External(external: "https://medium.com/@abjurato/swift-perfect-mustache-and-postgresql-on-heroku-48d483fe8489",
                 date: "30/04/2016",
                 title: "Swift, Perfect, mustache and PostgreSQL on Heroku")
    ]
}

enum Stories {
    static var all: [Story] = [ ]
    
    /*
        // our page with redirect
         
        Story(external: "https://medium.com/@abjurato/iterating-over-swiftui-views-delivered-in-a-swift-package-a6ffb98132ce",
              date: "23/06/2019",
              title: "Iterating over SwiftUI views delivered in a Swift Package"),
        
         
        // our page
         
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
        
         
        // not found page
         
        Story(filename: "16-03-2018.html", date: "16/03/2018", title: "Using Raspberry Pi as an Apple TimeMachine"),
         
    */
}
