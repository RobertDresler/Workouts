//
//  Realm+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RealmSwift

public extension Realm {

    func safeWrite(_ block: () -> Void) {
        do {
            try write { block() }
        } catch {
            print("Realm write error: \(error)")
        }
    }

}
