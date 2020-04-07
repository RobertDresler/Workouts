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

    var errorDescription: String? {
        switch self {
        case .cantSaveWorkoutToFirebase:
            return R.string.localizable.cantSaveWorkoutToFirebase()
        case .noDataReceivedFromFirebase:
            return R.string.localizable.noDataReceivedFromFirebase()
        }
    }

}
