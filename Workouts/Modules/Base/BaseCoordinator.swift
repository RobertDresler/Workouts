//
//  BaseCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

class BaseCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    func start() {}

    func addChild(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else { return }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension BaseCoordinator {
    func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return print("Coordinator: can't open url \(url.absoluteString)")
        }
        UIApplication.shared.open(url)
    }
}
