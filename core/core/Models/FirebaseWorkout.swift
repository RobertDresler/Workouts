//
//  FirebaseWorkout.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

public struct FirebaseWorkout: Workout, Codable {

    public var id: Int
    public var title: String
    public var place: String
    public var duration: TimeInterval

    public init(id: Int, title: String, place: String, duration: TimeInterval) {
        self.id = id
        self.title = title
        self.place = place
        self.duration = duration
    }

}
