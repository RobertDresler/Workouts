//
//  PlaceSelectorFactoryExtension.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

extension ModuleFactoryImp: PlaceSelectorFactory {
    func makePlaceSelectorView() -> PlaceSelectorView {
        let viewModel = PlaceSelectorViewModel()
        let viewController = PlaceSelectorViewController(viewModel: viewModel)
        return viewController
    }
}
