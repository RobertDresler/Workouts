//
//  WorkoutView.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

protocol WorkoutViewDelegate: class {
    func didSaveWorkout()
    func didSelectPlaceItem()
    func workoutViewDidTapCancelButton()
    func workoutViewWillBeDeinitialized()
}

protocol WorkoutView: BaseView {
    var delegate: WorkoutViewDelegate? { get set }
    func selectPlace(_ place: String)
}
