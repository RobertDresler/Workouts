//
//  UINavigationController+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public extension UINavigationController {
    @discardableResult func popViewControllerIfNeeded(animated: Bool) -> UIViewController? {
        guard topViewController?.shouldPopBack == true else { return nil }
        return popViewController(animated: animated)
    }
}
