//
//  BackHandleable.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

protocol BackHandleable: UIViewController {
    var shouldPopBack: Bool { get }
}

extension UIViewController: BackHandleable {
    /// Computed property which decides whether controller should be popped or not
    ///
    /// Override this computed property inside `UIViewController` if you need to decide
    /// whether controller should be popped or not.
    @objc open var shouldPopBack: Bool {
        return true
    }
}
