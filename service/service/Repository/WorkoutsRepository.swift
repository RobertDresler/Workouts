//
//  WorkoutsRepository.swift
//  service
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift

public protocol WorkoutsRepository {
    func add(_ workout: Workout) -> Single<Void>
    func getAll() -> Single<[Workout]>
    func delete(_ workout: Workout) -> Single<Void>
}
