//
//  CoordinatorFactory+WorkoutsList.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

extension CoordinatorFactoryImp {
    func makeWorkoutsListCoordinator(with router: Router) -> Coordinator {
        let coordinator = WorkoutsListCoordinator(
            router: router,
            factory: ModuleFactoryImp(),
            coordinatorFactory: CoordinatorFactoryImp()
        )
        return coordinator
    }
}
