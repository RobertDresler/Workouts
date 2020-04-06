//
//  Router.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

public protocol Router: Presentable {
    var routerForPresenting: Router { get }

    // MARK: Present
    func present(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func presentOverFullScreen(_ module: Presentable, animated flag: Bool, completion: (() -> Void)?)

    // MARK: Push
    func push(_ module: Presentable?, animated: Bool, onRemoval onRemovalCompletion: (() -> Void)?)

    // MARK: Pop
    @discardableResult
    func popModule(animated: Bool) -> Bool

    // MARK: Dismiss
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    // MARK: Set as Root Module
    func setRootModule(_ module: Presentable?)

    // MARK: Pop to Root Module
    func popToRootModule(animated: Bool)

    // MARK: Clean all previous view controllers except for root and the last one in navigation controller
    func cleanAllPrevious()
    func cleanStack(from indexFrom: Int)
    func cleanPrevious(_ number: Int)
    func insertBeforeLast(view: BaseView)
    func removeAllModules()
}

// MARK: Inferred methods

public extension Router {
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: animated, completion: nil)
    }
    func present(_ module: Presentable?, completion: (() -> Void)?) {
        present(module, animated: true, completion: completion)
    }
    func presentOverFullScreen(_ module: Presentable) {
        presentOverFullScreen(module, animated: true, completion: nil)
    }
    func presentOverFullScreen(_ module: Presentable, animated flag: Bool) {
        presentOverFullScreen(module, animated: flag, completion: nil)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }
    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, onRemoval: nil)
    }
    func push(_ module: Presentable?, onRemoval onRemovalCompletion: (() -> Void)?) {
        push(module, animated: true, onRemoval: onRemovalCompletion)
    }

    @discardableResult
    func popModule() -> Bool {
        return popModule(animated: true)
    }

    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
}
