//
//  WorkoutFactoryExtension.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import service

extension ModuleFactoryImp: WorkoutFactory {
    func makeWorkoutView(usage: WorkoutViewUsage) -> WorkoutView {
        let tempWorkout: Workout = {
            switch usage {
            case .create:
                return TempWorkout(id: -1, title: "", place: "", duration: 0)
            case .edit(let workout):
                if let realmWorkout = workout as? RealmWorkout {
                    return RealmWorkout(value: realmWorkout)
                } else {
                    return workout
                }
            }
        }()
        let viewModel = WorkoutViewModel(
            tempWorkout: tempWorkout,
            saver: WorkoutsSaver(
                workoutsProvider: WorkoutsProvider(
                    realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                    firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
                ),
                realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
            ),
            updater: WorkoutsUpdater(
                realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
            ),
            deleter: WorkoutsDeleter(
                realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
            ),
            usage: usage
        )
        let viewController = WorkoutViewController(viewModel: viewModel)
        return viewController
    }
}
