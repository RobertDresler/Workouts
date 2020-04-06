//
//  CoordinatorFactory.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

protocol CoordinatorFactory {
    func makeAppCoordinator(with rootController: NavigationController) -> AppCoordinator
    func makeWorkoutsListCoordinator(with router: Router) -> Coordinator
}
