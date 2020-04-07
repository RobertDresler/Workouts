//
//  WorkoutsDeleter.swift
//  service
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift

public final class WorkoutsDeleter {

    private let realmRepository: WorkoutsRepository
    private let firebaseRepository: WorkoutsRepository
    private let bag = DisposeBag()

    public init(
        realmWorkoutsRepository: WorkoutsRepository,
        firebaseWorkoutsRepository: WorkoutsRepository
    ) {
        self.realmRepository = realmWorkoutsRepository
        self.firebaseRepository = firebaseWorkoutsRepository
    }

    public func delete(_ workout: Workout, from repositoryType: RepositoryType) -> Single<Void> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.subscribeDeleteWorkout(with: single, workout: workout, repositoryType: repositoryType)
            return Disposables.create {}
        })
    }

    private func subscribeDeleteWorkout(
        with singleEvent: @escaping (SingleEvent<Void>) -> Void,
        workout: Workout,
        repositoryType: RepositoryType
    ) {
        deleteSingle(with: workout, for: repositoryType).subscribe(
            onSuccess: { singleEvent(.success(())) },
            onError: { singleEvent(.error($0)) }
        ).disposed(by: bag)
    }

    private func deleteSingle(with workout: Workout, for repositoryType: RepositoryType) -> Single<Void> {
        switch repositoryType {
        case .realm:
            return realmRepository.delete(workout)
        case .firebase:
            return firebaseRepository.delete(workout)
        }
    }

}
