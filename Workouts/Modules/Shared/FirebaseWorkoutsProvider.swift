//
//  FirebaseWorkoutsProvider.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift
import service

public final class FirebaseWorkoutsRepository: WorkoutsRepository {

    public init() {}

    public func add(_ workout: Workout) -> Single<Void> {
        // TODO: -RD- implement
        fatalError()
    }

    public func getAll() -> Single<[Workout]> {
        return Single.create(subscribe: { [weak self] single -> Disposable in

            // TODO: -RD- real providing
            // TODO: -RD- if error show toast
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                single(.success((1...15).map { _ in self.testWorkout(with: Int.random(in: 1...1000)) }))
            }

            return Disposables.create {}
        })
    }

    private func testWorkout(with id: Int) -> Workout {
        return FirebaseWorkout(id: id, title: "Firebase Test", place: "Test Place", duration: 180)
    }

}
