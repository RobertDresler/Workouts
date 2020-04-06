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
        // TODO: -RD- remove place
        let tempWorkout = TempWorkout(id: -1, title: "", place: "---", duration: 0)
        let viewModel = WorkoutViewModel(
            tempWorkout: tempWorkout,
            workoutsSaver: WorkoutsSaver(
                workoutsProvider: WorkoutsProvider(
                    realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                    firebaseRepository: FirebaseWorkoutsRepository()
                ),
                realmWorkoutsRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseWorkoutsRepository: FirebaseWorkoutsRepository()
            )
        )
        let viewController = WorkoutViewController(viewModel: viewModel)
        return viewController
    }
}
