//
//  WorkoutsListCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

final class WorkoutsListCoordinator: BaseCoordinator {

    private let router: Router
    private let factory: WorkoutsListFactory
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, factory: WorkoutsListFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        showWorkoutsListView()
    }

    private func showWorkoutsListView() {
        let workoutsListView = factory.makeWorkoutsListView()
        workoutsListView.delegate = self
        router.setRootModule(workoutsListView)
    }

}

extension WorkoutsListCoordinator: WorkoutsListViewDelegate {
    func didSelectWorkout(_ workout: Workout) {
        // TODO: -RD- implement
    }
}
