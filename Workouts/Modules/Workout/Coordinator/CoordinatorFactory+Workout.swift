//
//  CoordinatorFactory+Workout.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

extension CoordinatorFactoryImp {
    func makeWorkoutCoordinator(with router: Router) -> Coordinator & WorkoutCoordinatorOutput {
        let coordinator = WorkoutCoordinator(
            router: router,
            factory: ModuleFactoryImp(),
            coordinatorFactory: CoordinatorFactoryImp()
        )
        return coordinator
    }
}
