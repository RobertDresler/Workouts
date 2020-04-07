//
//  PlaceSelectorCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

protocol PlaceSelectorCoordinatorOutputDelegate: class {
    func placeSelectorCoordinatorDidFinish(_ coordinator: PlaceSelectorCoordinator, with place: String)
    func placeSelectorCoordinatorDidFinish(_ coordinator: PlaceSelectorCoordinator)
}

protocol PlaceSelectorCoordinatorOutput {
    var delegate: PlaceSelectorCoordinatorOutputDelegate? { get set }
}

final class PlaceSelectorCoordinator: BaseCoordinator, PlaceSelectorCoordinatorOutput {

    weak var delegate: PlaceSelectorCoordinatorOutputDelegate?

    private let router: Router
    private var placeSelectorRouter: Router?
    private let factory: PlaceSelectorFactory

    init(router: Router, factory: PlaceSelectorFactory) {
        self.router = router
        self.factory = factory
    }

    override func start() {
        showPlaceSelectorView()
    }

    private func showPlaceSelectorView() {
        let navigationController = NavigationController()
        navigationController.navigationBarPrefersLargeTitles = false
        placeSelectorRouter = RouterImp(rootController: navigationController)

        let placeSelectorView = factory.makePlaceSelectorView()
        placeSelectorView.delegate = self
        placeSelectorRouter?.push(placeSelectorView)
        router.present(navigationController)
    }

}

extension PlaceSelectorCoordinator: PlaceSelectorViewDelegate {
    func didSelectPlace(_ place: String) {
        router.dismissModule()
        delegate?.placeSelectorCoordinatorDidFinish(self, with: place)
    }

    func placeSelectorViewDidTapCancelButton() {
        router.dismissModule()
        delegate?.placeSelectorCoordinatorDidFinish(self)
    }

    func placeSelectorViewWillBeDeinitialized() {
        delegate?.placeSelectorCoordinatorDidFinish(self)
    }
}
