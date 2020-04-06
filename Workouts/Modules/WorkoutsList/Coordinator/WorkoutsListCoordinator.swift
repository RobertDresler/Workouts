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

    private struct ActionStorage {
        var didSaveWorkout: (() -> Void)?
    }

    private let router: Router
    private let factory: WorkoutsListFactory
    private let coordinatorFactory: CoordinatorFactory
    private var actionStorage: ActionStorage

    init(router: Router, factory: WorkoutsListFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.actionStorage = ActionStorage()
    }

    override func start() {
        showWorkoutsListView()
    }

    private func showWorkoutsListView() {
        let workoutsListView = factory.makeWorkoutsListView()
        workoutsListView.delegate = self
        actionStorage.didSaveWorkout = { [weak workoutsListView] in
            workoutsListView?.loadData()
        }
        router.setRootModule(workoutsListView)
    }

}

extension WorkoutsListCoordinator: WorkoutsListViewDelegate {
    func newWorkoutButtonPressed() {
        runNewWorkoutCoordinator()
    }

    private func runNewWorkoutCoordinator() {
        var coordinator = coordinatorFactory.makeWorkoutCoordinator(with: router)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }

    func didSelectWorkout(_ workout: Workout) {
        // TODO: -RD- implement if needed
    }
}

extension WorkoutsListCoordinator: WorkoutCoordinatorOutputDelegate {
    func workoutCoordinatorDidFinishSuccessfully(_ coordinator: WorkoutCoordinator) {
        actionStorage.didSaveWorkout?()
        removeChild(coordinator)
    }

    func workoutCoordinatorDidFinish(_ coordinator: WorkoutCoordinator) {
        removeChild(coordinator)
    }
}
