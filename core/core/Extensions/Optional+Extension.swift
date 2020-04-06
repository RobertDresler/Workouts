//
//  Optional+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

extension Optional where Wrapped == String {

    public var nilIfEmpty: String? {
        guard let unwrapped = self else { return nil }
        return unwrapped.isEmpty ? nil : unwrapped
    }

    public var emptyIfNil: String {
        guard let unwrapped = self else { return "" }
        return unwrapped
    }

    public var isEmptyOrNil: Bool {
        guard let unwrapped = self else { return true }
        return unwrapped.isEmpty
    }

}
