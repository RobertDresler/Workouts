//
//  RouterImp.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

final class RouterImp: NSObject, Router {

    var routerForPresenting: Router { return self }

    private weak var rootController: UINavigationController?
    private var onRemovalCompletions: [UIViewController: () -> Void]

    init(rootController: UINavigationController) {
        self.rootController = rootController
        onRemovalCompletions = [:]
        super.init()
        (rootController as? NavigationController)?.customDelegate = self
    }

    var toPresent: UIViewController? {
        return rootController
    }

    func present(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent else { return }
        rootController?.present(controller, animated: animated, completion: completion)
    }

    func presentOverFullScreen(_ module: Presentable, animated flag: Bool, completion: (() -> Void)?) {
        guard let toPresentVC = module.toPresent else { return }
        toPresentVC.modalPresentationStyle = .overFullScreen
        present(toPresentVC, animated: flag, completion: completion)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    func push(_ module: Presentable?, animated: Bool, onRemoval onRemovalCompletion: (() -> Void)?) {
        guard
            let controller = module?.toPresent,
            (controller is UINavigationController == false)
        else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }

        if let onRemovalCompletion = onRemovalCompletion {
            onRemovalCompletions[controller] = onRemovalCompletion
        }

        if rootController?.viewControllers.isEmpty ?? true {
            setRootModule(module)
        } else {
            rootController?.pushViewController(controller, animated: animated)
        }
    }

    @discardableResult
    func popModule(animated: Bool) -> Bool {
        guard let controller = rootController?.popViewControllerIfNeeded(animated: animated) else { return false }
        runCompletion(for: controller)
        return true
    }

    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        rootController?.dismiss(animated: false)
        rootController?.setViewControllers([controller], animated: false)
    }

    func cleanAllPrevious() {
        guard
            let navController = rootController,
            let rootVC = navController.viewControllers.first,
            let topVC = navController.viewControllers.last,
            topVC !== rootVC
        else { return }

        navController.viewControllers = [rootVC, topVC]
    }

    func cleanPrevious(_ number: Int) {
        guard
            let navController = rootController,
            let topViewController = navController.viewControllers.last
        else { return }

        let numberOfViewControllers = navController.viewControllers.count
        let endIndex = numberOfViewControllers - number - 1
        var stack = Array(navController.viewControllers[..<endIndex])
        stack.append(topViewController)
        navController.viewControllers = stack
    }

    func cleanStack(from indexFrom: Int) {
        guard
            let navController = rootController,
            let topViewController = navController.viewControllers.last
        else { return }

        var stack = Array(navController.viewControllers[..<indexFrom])
        stack.append(topViewController)
        navController.viewControllers = stack
    }

    func insertBeforeLast(view: BaseView) {
        guard
            let navController = rootController,
            let viewController = view.toPresent
        else { return }

        let lastButOneIndex = navController.viewControllers.count - 1
        navController.viewControllers.insert(viewController, at: lastButOneIndex)
    }

    func popToRootModule(animated: Bool) {
        let controllers = rootController?.viewControllers
        rootController?.popToRootViewController(animated: animated)
        controllers?.forEach { onRemovalCompletions.removeValue(forKey: $0) }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = onRemovalCompletions[controller] else { return }
        completion()
        onRemovalCompletions.removeValue(forKey: controller)
    }

    func removeAllModules() {
        rootController?.viewControllers = []
    }

}

extension RouterImp: NavigationControllerDelegate {
    func didPop(_ viewController: UIViewController) {
        runCompletion(for: viewController)
    }
}
