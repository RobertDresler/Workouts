//
//  WorkoutsListView.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

protocol WorkoutsListViewDelegate: class {
    func newWorkoutButtonPressed()
    func didSelectWorkout(_ workout: Workout)
}

protocol WorkoutsListView: BaseView {
    var delegate: WorkoutsListViewDelegate? { get set }
    func loadData()
    func deleteWorkout(_ workout: Workout)
}
