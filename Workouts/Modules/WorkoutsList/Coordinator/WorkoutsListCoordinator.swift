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
        var didChooseDeleteWorkout: ((Workout) -> Void)?
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
        actionStorage.didChooseDeleteWorkout = { [weak workoutsListView] workout in
            workoutsListView?.deleteWorkout(workout)
        }
        router.setRootModule(workoutsListView)
    }

}

extension WorkoutsListCoordinator: WorkoutsListViewDelegate {
    func newWorkoutButtonPressed() {
        runCreateWorkoutCoordinator()
    }

    private func runCreateWorkoutCoordinator() {
        var coordinator = coordinatorFactory.makeWorkoutCoordinator(with: router, usage: .create)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }

    func didSelectWorkout(_ workout: Workout) {
        showActionSheet(with: workout)
    }

    private func showActionSheet(with workout: Workout) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: R.string.localizable.workoutActionSheetCancel(), style: .cancel)
        let deleteAction = UIAlertAction(
            title: R.string.localizable.workoutActionSheetDelete(),
            style: .destructive,
            handler: { [weak self] _ in self?.actionStorage.didChooseDeleteWorkout?(workout) }
        )
        let editAction = UIAlertAction(
            title: R.string.localizable.workoutActionSheetEdit(),
            style: .default,
            handler: { [weak self] _ in self?.runEditWorkoutCoordinator(with: workout) })
        [editAction, deleteAction, cancelAction].forEach(alertController.addAction(_:))
        router.presentOverFullScreen(alertController)
    }

    private func runEditWorkoutCoordinator(with workout: Workout) {
        var coordinator = coordinatorFactory.makeWorkoutCoordinator(with: router, usage: .edit(workout))
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
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
