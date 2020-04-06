//
//  Configurable.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

public protocol Configurable {
    associatedtype ViewModel
    func configure(for viewModel: ViewModel)
}

public extension Configurable {
    func configured(for viewModel: ViewModel) -> Self {
        configure(for: viewModel)
        return self
    }
}
