//
//  RealmWorkout.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RealmSwift

public final class RealmWorkout: Object, Workout {

    @objc public dynamic var id = 0
    @objc public dynamic var title = ""

    public init(
        id: Int,
        title: String
    ) {
        self.id = id
        self.title = title
    }

    required init() {}

    override public class func primaryKey() -> String? {
        return "id"
    }

}
