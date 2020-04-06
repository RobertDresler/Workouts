//
//  CoordinatorFactory+AppCoordinator.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

extension CoordinatorFactoryImp {
    func makeAppCoordinator(with rootController: NavigationController) -> AppCoordinator {
        let appCoordinator = AppCoordinator(
            router: RouterImp(rootController: rootController),
            //factory: ModuleFactoryImp(),
            coordinatorFactory: CoordinatorFactoryImp()
        )
        return appCoordinator
    }
}
