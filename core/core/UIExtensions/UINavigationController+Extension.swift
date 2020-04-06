//
//  UINavigationController+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public extension UINavigationController {

    func removeViewController(_ viewController: UIViewController) {
        var viewControllers = self.viewControllers
        guard let index = viewControllers.firstIndex(of: viewController) else {
            return assertionFailure("View controller: \(viewController) is not in stack")
        }
        viewControllers.remove(at: index)
        self.viewControllers = viewControllers
    }

    @discardableResult func popViewControllerIfNeeded(animated: Bool) -> UIViewController? {
        guard topViewController?.shouldPopBack == true else { return nil }
        return popViewController(animated: animated)
    }

}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
