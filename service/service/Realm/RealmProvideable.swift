//
//  RealmProvideable.swift
//  service
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RealmSwift

public protocol RealmProvideable {
    var realm: Realm { get set }
}
