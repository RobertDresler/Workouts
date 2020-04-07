//
//  FirebaseWorkoutsProvider.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import Firebase
import RxSwift
import service

public final class FirebaseWorkoutsRepository: WorkoutsRepository {

    private let database: Firestore

    public init(database: Firestore) {
        self.database = database
    }

    public func add(_ workout: Workout) -> Single<Void> {
        // TODO: -RD- implement
        fatalError()
    }

    public func getAll() -> Single<[Workout]> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.database.collection(Constants.firestoreWorkoutsCollection).getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    if let error = error {
                        single(.error(error))
                    }
                    return
                }
                let workouts = snapshot.documents.compactMap { (document: QueryDocumentSnapshot) -> Workout? in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                        let decoded = try JSONDecoder().decode(FirebaseWorkout.self, from: data)
                        return decoded
                    } catch {
                        return nil
                    }
                }
                single(.success(workouts))
            }
            return Disposables.create {}
        })
    }

}
