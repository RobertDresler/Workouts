//
//  WorkoutsSaver.swift
//  service
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift

public final class WorkoutsSaver {

    private let workoutsProvider: WorkoutsProvider
    private let realmWorkoutsRepository: WorkoutsRepository
    private let firebaseWorkoutsRepository: WorkoutsRepository
    private let bag = DisposeBag()

    public init(
        workoutsProvider: WorkoutsProvider,
        realmWorkoutsRepository: WorkoutsRepository,
        firebaseWorkoutsRepository: WorkoutsRepository
    ) {
        self.workoutsProvider = workoutsProvider
        self.realmWorkoutsRepository = realmWorkoutsRepository
        self.firebaseWorkoutsRepository = firebaseWorkoutsRepository
    }

    public func save(_ workout: Workout, to repositoryType: RepositoryType) -> Single<Void> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            self?.subscribeGetMaxId(with: single, workout: workout, repositoryType: repositoryType)
            return Disposables.create {}
        })
    }

    private func subscribeGetMaxId(
        with singleEvent: @escaping (SingleEvent<Void>) -> Void,
        workout: Workout,
        repositoryType: RepositoryType
    ) {
        getMaxId()
            .map { id in
                var temp = workout
                temp.id = id
                return temp
            }
            .subscribe(
                onSuccess: { [weak self] workout in
                    self?.subscribeAddWorkout(
                        with: singleEvent,
                        workout: workout,
                        repositoryType: repositoryType
                    )
                },
                onError: { singleEvent(.error($0)) }
            )
            .disposed(by: bag)
    }

    private func getMaxId() -> Single<Int> {
        workoutsProvider.loadData()
        return workoutsProvider.workouts.filter { !$0.isEmpty }.first()
            .map { workouts in workouts?.map { workout in workout.id }.max() ?? 0 }
    }

    private func subscribeAddWorkout(
        with singleEvent: @escaping (SingleEvent<Void>) -> Void,
        workout: Workout,
        repositoryType: RepositoryType
    ) {
        addSingle(with: workout, for: repositoryType).subscribe(
            onSuccess: { singleEvent(.success(())) },
            onError: { singleEvent(.error($0)) }
        ).disposed(by: bag)
    }

    private func addSingle(with workout: Workout, for repositoryType: RepositoryType) -> Single<Void> {
        switch repositoryType {
        case .realm:
            return realmWorkoutsRepository.add(workout)
        case .firebase:
            return firebaseWorkoutsRepository.add(workout)
        }
    }

}
