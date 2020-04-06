//
//  AppCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

final class AppCoordinator: BaseCoordinator {

    private let router: Router
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        runWorkoutsListCoordinator()
    }

    private func runWorkoutsListCoordinator() {
        let coordinator = coordinatorFactory.makeWorkoutsListCoordinator(with: router)
        addChild(coordinator)
        coordinator.start()
    }

}
