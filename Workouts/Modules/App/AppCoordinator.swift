//
//  AppCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import service
import UIKit

final class AppCoordinator: BaseCoordinator {

    private let router: Router
    //private let factory: ActivityIndicatorFactory
    private let coordinatorFactory: CoordinatorFactory

    init(
        router: Router,
       // factory: ActivityIndicatorFactory,
        coordinatorFactory: CoordinatorFactory
    ) {
        self.router = router
        //self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {

        router.setRootModule(ViewController())
    }

    /*private func runTabBarCoordinator() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(with: router)
        addChild(coordinator)
        coordinator.start()
    }

    private func runFirstLaunchCoordinator() {
        let coordinator = coordinatorFactory.makeFirstLaunchCoordinator(with: router)
        addChild(coordinator)
        coordinator.start()
    }*/

}
