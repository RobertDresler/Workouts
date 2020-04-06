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
    @objc public dynamic var place = ""
    @objc public dynamic var duration: TimeInterval = 0

    public init(id: Int, title: String, place: String, duration: TimeInterval) {
        self.id = id
        self.title = title
        self.place = place
        self.duration = duration
    }

    required init() {}

    override public class func primaryKey() -> String? {
        return "id"
    }

}
