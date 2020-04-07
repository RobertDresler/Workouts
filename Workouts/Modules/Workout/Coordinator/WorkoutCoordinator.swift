//
//  WorkoutCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

protocol WorkoutCoordinatorOutputDelegate: class {
    func workoutCoordinatorDidFinishSuccessfully(_ coordinator: WorkoutCoordinator)
    func workoutCoordinatorDidFinish(_ coordinator: WorkoutCoordinator)
}

protocol WorkoutCoordinatorOutput {
    var delegate: WorkoutCoordinatorOutputDelegate? { get set }
}

final class WorkoutCoordinator: BaseCoordinator, WorkoutCoordinatorOutput {

    private struct ActionStorage {
        var didSelectPlace: ((String) -> Void)?
    }

    weak var delegate: WorkoutCoordinatorOutputDelegate?

    private let router: Router
    private var workoutRouter: Router?
    private let factory: WorkoutFactory
    private let coordinatorFactory: CoordinatorFactory
    private var actionStorage: ActionStorage

    init(router: Router, factory: WorkoutFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.actionStorage = ActionStorage()
    }

    override func start() {
        showWorkoutView()
    }

    private func showWorkoutView() {
        let navigationController = NavigationController()
        workoutRouter = RouterImp(rootController: navigationController)

        let workoutView = factory.makeWorkoutView()
        workoutView.delegate = self
        actionStorage.didSelectPlace = { [weak workoutView] place in
            workoutView?.selectPlace(place)
        }

        workoutRouter?.push(workoutView)
        router.present(navigationController)
    }

}

extension WorkoutCoordinator: WorkoutViewDelegate {
    func didSaveWorkout() {
        router.dismissModule()
        delegate?.workoutCoordinatorDidFinishSuccessfully(self)
    }

    func didSelectPlaceItem() {
        runPlaceSelectorCoordinator()
    }

    private func runPlaceSelectorCoordinator() {
        guard let router = workoutRouter else { return }
        var coordinator = coordinatorFactory.makePlaceSelectorCoordinator(with: router)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }

    func workoutViewDidTapCancelButton() {
        router.dismissModule()
        delegate?.workoutCoordinatorDidFinish(self)
    }

    func workoutViewWillBeDeinitialized() {
        delegate?.workoutCoordinatorDidFinish(self)
    }
}

extension WorkoutCoordinator: PlaceSelectorCoordinatorOutputDelegate {
    func placeSelectorCoordinatorDidFinish(_ coordinator: PlaceSelectorCoordinator, with place: String) {
        actionStorage.didSelectPlace?(place)
        removeChild(coordinator)
    }

    func placeSelectorCoordinatorDidFinish(_ coordinator: PlaceSelectorCoordinator) {
        removeChild(coordinator)
    }
}
