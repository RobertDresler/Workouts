//
//  CoordinatorFactory+Workout.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

extension CoordinatorFactoryImp {
    func makePlaceSelectorCoordinator(with router: Router) -> Coordinator & PlaceSelectorCoordinatorOutput {
        let coordinator = PlaceSelectorCoordinator(router: router, factory: ModuleFactoryImp())
        return coordinator
    }
}
