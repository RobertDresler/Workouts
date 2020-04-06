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

    weak var delegate: WorkoutCoordinatorOutputDelegate?

    private let router: Router
    private var workoutRouter: Router?
    private let factory: WorkoutFactory

    init(router: Router, factory: WorkoutFactory) {
        self.router = router
        self.factory = factory
    }

    override func start() {
        showWorkoutView()
    }

    private func showWorkoutView() {
        // TODO: -RD-
        //let navigationController = NavigationControllerAssembly.initNavigationController()
        let navigationController = NavigationController()
        workoutRouter = RouterImp(rootController: navigationController)

        let workoutView = factory.makeWorkoutView()
        workoutView.delegate = self
        workoutRouter?.push(workoutView)
        router.present(navigationController)
    }

}

extension WorkoutCoordinator: WorkoutViewDelegate {
    func didSaveWorkout() {
        router.dismissModule()
        delegate?.workoutCoordinatorDidFinishSuccessfully(self)
    }

    func workoutViewDidTapCancelButton() {
        router.dismissModule()
        delegate?.workoutCoordinatorDidFinish(self)
    }

    func workoutViewWillBeDeinitialized() {
        delegate?.workoutCoordinatorDidFinish(self)
    }
}
