//
//  WorkoutsProvider.swift
//  service
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxCocoa
import RxSwift

public final class WorkoutsProvider {

    public enum Mode: CaseIterable {
        case all
        case realm
        case firebase
    }

    public var mode: Mode = .all
    public let workouts = BehaviorRelay<[Workout]>(value: [])
    public let error = BehaviorRelay<Error?>(value: nil)

    private var operations = 0
    private var completedOperations = 0
    private var bag = DisposeBag()
    private var tempError: Error?
    private var tempWorkouts = [Workout]()

    private let realmRepository: WorkoutsRepository
    private let firebaseRepository: WorkoutsRepository
    private var onWorkoutsLoaded: (([Workout]) -> Void)?

    public init(realmRepository: WorkoutsRepository, firebaseRepository: WorkoutsRepository) {
        self.realmRepository = realmRepository
        self.firebaseRepository = firebaseRepository
    }

    public func changeMode() {
        guard let currentModeIndex = Mode.allCases.firstIndex(of: mode) else { return }
        mode = Mode.allCases[safe: currentModeIndex + 1] ?? .all
        loadData()
    }

    public func loadData(onWorkoutsLoaded: (([Workout]) -> Void)? = nil) {
        self.onWorkoutsLoaded = onWorkoutsLoaded
        bag = DisposeBag()
        operations = mode == .all ? 2 : 1
        completedOperations = 0
        tempError = nil
        tempWorkouts = []

        if [.all, .realm].contains(mode) {
            realmRepository.getAll().subscribe(
                onSuccess: { [weak self] in self?.process(with: $0) },
                onError: { [weak self] in self?.process(with: $0) }
            ).disposed(by: bag)
        }

        if [.all, .firebase].contains(mode) {
            firebaseRepository.getAll().subscribe(
                onSuccess: { [weak self] in self?.process(with: $0) },
                onError: { [weak self] in self?.process(with: $0) }
            ).disposed(by: bag)
        }
    }

    private func process(with workouts: [Workout]) {
        completedOperations += 1
        tempWorkouts.append(contentsOf: workouts)
        processAfterCompletedOperation()
    }

    private func process(with error: Error) {
        completedOperations += 1
        tempError = error
        processAfterCompletedOperation()

    }

    private func processAfterCompletedOperation() {
        guard completedOperations == operations else { return }
        if let tempError = tempError {
            error.accept(tempError)
        } else {
            // NOTE: -1 is here because of Firebase model which cannout be deleted.
            workouts.accept(tempWorkouts.sorted { $0.id < $1.id }.filter { $0.id != -1 })
            onWorkoutsLoaded?(workouts.value)
        }
    }

}
