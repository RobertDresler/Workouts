//
//  WorkoutFactoryExtension.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import service

extension ModuleFactoryImp: WorkoutFactory {
    func makeWorkoutView() -> WorkoutView {
        let tempWorkout = TempWorkout(id: -1, title: "", place: "", duration: 0)
        let viewModel = WorkoutViewModel(tempWorkout: tempWorkout)
        let viewController = WorkoutViewController(viewModel: viewModel)
        return viewController
    }
}
