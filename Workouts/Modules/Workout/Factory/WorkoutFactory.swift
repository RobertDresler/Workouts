//
//  WorkoutFactory.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

protocol WorkoutFactory {
    func makeWorkoutView() -> WorkoutView
    // TODO: -RD- makeEditWorkoutView(for:) if needed
}
