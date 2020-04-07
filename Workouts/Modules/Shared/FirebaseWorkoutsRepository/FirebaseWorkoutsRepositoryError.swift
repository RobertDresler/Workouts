//
//  FirebaseWorkoutsRepositoryError.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import Foundation

enum FirebaseWorkoutsRepositoryError: LocalizedError {

    case cantSaveWorkoutToFirebase
    case noDataReceivedFromFirebase
    case cantUpdateWorkoutInFirebase
    case cantDeleteWorkoutFromFirebase

    var errorDescription: String? {
        switch self {
        case .cantSaveWorkoutToFirebase:
            return R.string.localizable.cantSaveWorkoutToFirebase()
        case .noDataReceivedFromFirebase:
            return R.string.localizable.noDataReceivedFromFirebase()
        case .cantUpdateWorkoutInFirebase:
            return R.string.localizable.cantUpdateWorkoutInFirebase()
        case .cantDeleteWorkoutFromFirebase:
            return R.string.localizable.cantDeleteWorkoutFromFirebase()
        }
    }

}
