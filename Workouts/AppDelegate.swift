//
//  AppDelegate.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import Firebase
import UIKit
import WorkoutsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var rootController: NavigationController {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.tintColor = Color.globalTint
        return navigationController
    }

    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        FirebaseApp.configure()

        appCoordinator = CoordinatorFactoryImp().makeAppCoordinator(with: rootController)
        appCoordinator?.start()

        return true
    }

}
