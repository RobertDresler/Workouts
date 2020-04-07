//
//  FirebaseWorkoutsRepository.swift
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
        let firebaseWorkout = FirebaseWorkout(
            id: workout.id,
            title: workout.title,
            place: workout.place,
            duration: workout.duration
        )
        let documentData: [String: Any]
        do {
            let data = try JSONEncoder().encode(firebaseWorkout)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonData = jsonObject as? [String: Any] else {
                return .error(FirebaseWorkoutsRepositoryError.cantSaveWorkoutToFirebase)
            }
            documentData = jsonData
        } catch {
            return .error(FirebaseWorkoutsRepositoryError.cantSaveWorkoutToFirebase)
        }
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.database.collection(Constants.firestoreWorkoutsCollection).addDocument(data: documentData) { error in
                guard error == nil else {
                    single(.error(FirebaseWorkoutsRepositoryError.cantSaveWorkoutToFirebase))
                    return
                }
                single(.success(()))
            }
            return Disposables.create {}
        })
    }

    public func getAll() -> Single<[Workout]> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.database.collection(Constants.firestoreWorkoutsCollection).getDocuments { snapshot, _ in
                guard let snapshot = snapshot else {
                    single(.error(FirebaseWorkoutsRepositoryError.noDataReceivedFromFirebase))
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

    public func delete(_ workout: Workout) -> Single<Void> {
        return Single.create(subscribe: { [weak self] single -> Disposable in

            self?.database.collection(Constants.firestoreWorkoutsCollection)
                .whereField("id", isEqualTo: workout.id)
                .getDocuments { snapshot, _ in
                    guard let snapshot = snapshot else {
                        single(.error(FirebaseWorkoutsRepositoryError.cantDeleteWorkoutFromFirebase))
                        return
                    }
                    snapshot.documents.forEach { document in
                        document.reference.delete { error in
                            guard error == nil else {
                                single(.error(FirebaseWorkoutsRepositoryError.cantDeleteWorkoutFromFirebase))
                                return
                            }
                            single(.success(()))
                        }
                    }
                }
            return Disposables.create {}
        })
    }

}
