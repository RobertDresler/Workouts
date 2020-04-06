//
//  StaticDateFormatters.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import Foundation

public extension DateFormatter {

    /// DateFormat: **d.M.yyyy**
    static let dMyyyy = DateFormatter(dateFormat: "d.M.yyyy")

    /// Initializer which creates `DateFormatter` with given `dateFormat`
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }

}
