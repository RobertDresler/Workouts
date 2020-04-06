//
//  WorkoutsListFactoryExtension.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import service

extension ModuleFactoryImp: WorkoutsListFactory {
    func makeWorkoutsListView() -> WorkoutsListView {
        let viewModel = WorkoutsListViewModel(
            workoutsProvider: WorkoutsProvider(
                realmRepository: RealmWorkoutsRepository(),
                firebaseRepository: FirebaseWorkoutsRepository()
            )
        )
        let viewController = WorkoutsListViewController(viewModel: viewModel)
        return viewController
    }
}