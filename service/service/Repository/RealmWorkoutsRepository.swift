//
//  RealmWorkoutsRepository.swift
//  service
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift

public final class RealmWorkoutsRepository: WorkoutsRepository {

    public init() {} // TODO: -RD- realm provider

    public func add(_ workout: Workout) -> Single<Void> {
        // TODO: -RD- implement
        fatalError()
    }

    public func getAll() -> Single<[Workout]> {
        return Single.create(subscribe: { [weak self] single -> Disposable in

            guard let self = self else { return Disposables.create {} }
            // TODO: -RD- real providing
            single(.success((1...15).map { _ in self.testWorkout(with: Int.random(in: 1...1000)) }))

            return Disposables.create {}
        })
    }

    private func testWorkout(with id: Int) -> Workout {
        return RealmWorkout(id: id, title: "Realm Test", place: "Test Place", duration: 180)
    }

}
