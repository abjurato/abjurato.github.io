//
//  main.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation

let outputDirectory = URL(fileURLWithPath: CommandLine.arguments.last!, isDirectory: true)
Website(base: URL(string: "https://abjurato.github.io/")!).render(base: outputDirectory)
