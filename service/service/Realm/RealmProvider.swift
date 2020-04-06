//
//  RealmProvider.swift
//  service
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RealmSwift

public final class RealmProvider: RealmProvideable {

    public var realm: Realm = {
        do {
            return try Realm()
        } catch {
            fatalError(
                "Realm instance can't be initialized, did you forget to apply migrations or increment database version?"
                    + "\nError: \(error)"
            )
        }
    }()

    public init() {}

}
