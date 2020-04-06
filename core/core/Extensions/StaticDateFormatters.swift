//
//  StaticDateFormatters.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import Foundation

public extension DateFormatter {

    /// DateFormat: **H:mm**
    static let HmmInterval: DateFormatter = {
        let dateFormatter = DateFormatter(dateFormat: "H:mm")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()

    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }

}
