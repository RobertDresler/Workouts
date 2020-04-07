//
//  WorkoutsListFactoryExtension.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import FirebaseFirestore
import service

extension ModuleFactoryImp: WorkoutsListFactory {
    func makeWorkoutsListView() -> WorkoutsListView {
        let viewModel = WorkoutsListViewModel(
            workoutsProvider: WorkoutsProvider(
                realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
            ),
            workoutsDeleter: WorkoutsDeleter(
                realmRepository: RealmWorkoutsRepository(realm: RealmProvider().realm),
                firebaseRepository: FirebaseWorkoutsRepository(database: .firestore())
            )
        )
        let viewController = WorkoutsListViewController(viewModel: viewModel)
        return viewController
    }
}
