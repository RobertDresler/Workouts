//
//  RealmWorkoutsRepository.swift
//  service
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RealmSwift
import RxSwift

public final class RealmWorkoutsRepository: WorkoutsRepository {

    private let realm: Realm

    public init(realm: Realm) {
        self.realm = realm
    }

    public func add(_ workout: Workout) -> Single<Void> {
        let realmWorkout = RealmWorkout(
            id: workout.id,
            title: workout.title,
            place: workout.place,
            duration: workout.duration
        )
        realm.safeWrite {
            realm.add(realmWorkout)
        }
        return .just(())
    }

    public func getAll() -> Single<[Workout]> {
        return .just(Array(realm.objects(RealmWorkout.self)))
    }

    public func update(_ workout: Workout) -> Single<Void> {
        let realmWorkout = RealmWorkout(
            id: workout.id,
            title: workout.title,
            place: workout.place,
            duration: workout.duration
        )
        realm.safeWrite {
            realm.add(realmWorkout, update: .modified)
        }
        return .just(())
    }

    public func delete(_ workout: Workout) -> Single<Void> {
        if let realmWorkout = realm.object(ofType: RealmWorkout.self, forPrimaryKey: workout.id) {
            realm.safeWrite {
                realm.delete(realmWorkout)
            }
        }
        return .just(())
    }

}
