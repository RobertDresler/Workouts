//
//  RepositoryType.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

enum RepositoryType: Int, CaseIterable {
    
    case realm
    case firebase

    var title: String {
        switch self {
        case .realm:
            return R.string.localizable.workoutRepositoryTypeItemRealmSegment()
        case .firebase:
            return R.string.localizable.workoutRepositoryTypeItemFirebaseSegment()
        }
    }

}
