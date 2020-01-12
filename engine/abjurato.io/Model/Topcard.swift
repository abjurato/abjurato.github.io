//
//  Topcard.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 12/01/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation


class Topcard: Story {
    var imagePath: String
    
    init(filename: String, date: String, title: String, imagePath: String, constructor: HTMLConstructor? = nil) {
        self.imagePath = imagePath
        super.init(filename: filename, date: date, title: title, constructor: constructor)
    }
}
