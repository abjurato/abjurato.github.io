//
//  String+Extension.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation

extension String {
    func removingBrackets() -> String {
        var temp = self
        temp.removeLast(2)
        return temp
    }
}

extension String {
    func filenameCharacters() -> String {
        var invalidCharacters = CharacterSet(charactersIn: ":/")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)

        let newString = self
            .components(separatedBy: invalidCharacters)
            .joined(separator: "_")

        return newString
   }
}
