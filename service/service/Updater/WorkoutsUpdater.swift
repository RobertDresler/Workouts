//
//  WorkoutsUpdater.swift
//  service
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift

public final class WorkoutsUpdater {

    private let realmRepository: WorkoutsRepository
    private let firebaseRepository: WorkoutsRepository
    private let bag = DisposeBag()

    public init(realmRepository: WorkoutsRepository, firebaseRepository: WorkoutsRepository) {
        self.realmRepository = realmRepository
        self.firebaseRepository = firebaseRepository
    }

    public func update(_ workout: Workout, in repositoryType: RepositoryType) -> Single<Void> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.subscribeUpdateWorkout(with: single, workout: workout, repositoryType: repositoryType)
            return Disposables.create {}
        })
    }

    private func subscribeUpdateWorkout(
        with singleEvent: @escaping (SingleEvent<Void>) -> Void,
        workout: Workout,
        repositoryType: RepositoryType
    ) {
        updateSingle(with: workout, for: repositoryType).subscribe(
            onSuccess: { singleEvent(.success(())) },
            onError: { singleEvent(.error($0)) }
        ).disposed(by: bag)
    }

    private func updateSingle(with workout: Workout, for repositoryType: RepositoryType) -> Single<Void> {
        switch repositoryType {
        case .realm:
            return realmRepository.update(workout)
        case .firebase:
            return firebaseRepository.update(workout)
        }
    }

}
