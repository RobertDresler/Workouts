//
//  NavigationController.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import SnapKit
import UIKit
import WorkoutsUI

protocol NavigationControllerDelegate: class {
    func didPop(_ viewController: UIViewController)
}

final class NavigationController: UINavigationController {

    weak var customDelegate: NavigationControllerDelegate?

    private var duringPushAnimation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }

}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        duringPushAnimation = false
        if
        let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
        !navigationController.viewControllers.contains(poppedViewController) {
            customDelegate?.didPop(poppedViewController)
        }
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1
            && duringPushAnimation == false
            && (topViewController?.shouldPopBack ?? true) == true
    }
}

extension UIViewController {
    var customNavigationController: NavigationController? {
        return navigationController as? NavigationController
    }
}
