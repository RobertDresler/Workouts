//
//  WorkoutsListViewModel.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxCocoa
import RxSwift
import service
import WorkoutsUI

final class WorkoutsListViewModel: BViewModel {

    var title: String {
        return R.string.localizable.workoutsListTitle()
    }

    enum State: Equatable {
        case initial
        case loading
        case loadingWithChangeMode
        case loaded
        case errorReceived(String)
    }

    typealias DataSourceItem = (model: Workout, viewModel: WorkoutCellViewModel)

    let bag = DisposeBag()
    let state = BehaviorRelay<State>(value: .initial)
    var dataSource = [DataSourceItem]()
    let isActivityIndicatorLoading = BehaviorRelay<Bool>(value: false)
    let isModeBarButtonItemEnabled = BehaviorRelay<Bool>(value: false)

    var modeBarButtonTitle: String {
        switch workoutsProvider.mode {
        case .all:
            return R.string.localizable.workoutsListModeAll()
        case .realm:
            return R.string.localizable.workoutsListModeRealm()
        case .firebase:
            return R.string.localizable.workoutsListModeFirebase()
        }
    }

    private let workoutsProvider: WorkoutsProvider
    private let workoutsDeleter: WorkoutsDeleter

    init(workoutsProvider: WorkoutsProvider, workoutsDeleter: WorkoutsDeleter) {
        self.workoutsProvider = workoutsProvider
        self.workoutsDeleter = workoutsDeleter
        setupBinding()
    }

    private func setupBinding() {
        state.map { [.loading, .loadingWithChangeMode].contains($0) }
            .bind(to: isActivityIndicatorLoading)
            .disposed(by: bag)
        
        state.map { $0 != .loading }.bind(to: isModeBarButtonItemEnabled).disposed(by: bag)

        workoutsProvider.workouts.bind { [weak self] workouts in
            guard let self = self else { return }
            self.dataSource = workouts.map { ($0, self.viewModel(for: $0)) }
            self.state.accept(.loaded)
        }.disposed(by: bag)

        workoutsProvider.error.bind { [weak self] error in
            guard let error = error else { return }
            self?.process(with: error)
        }.disposed(by: bag)
    }

    func loadData() {
        guard ![.loading, .loadingWithChangeMode].contains(state.value) else { return }
        state.accept(.loading)
        workoutsProvider.loadData()
    }

    func changeMode() {
        state.accept(.loadingWithChangeMode)
        workoutsProvider.changeMode()
    }

    func deleteWorkout(_ workout: Workout) {
        guard ![.loading, .loadingWithChangeMode].contains(state.value) else { return }
        workoutsDeleter.delete(workout, from: (workout is RealmWorkout) ? .realm : .firebase).subscribe(
            onSuccess: { [weak self] in self?.workoutsProvider.loadData() },
            onError: { [weak self] in self?.process(with: $0) }
        ).disposed(by: bag)
    }

    private func viewModel(for workout: Workout) -> WorkoutCellViewModel {
        return WorkoutCellViewModel(
            title: workout.title,
            place: workout.place,
            duration: R.string.localizable.workoutCellDuration(
                DateFormatter.HmmInterval.string(from: Date(timeIntervalSince1970: workout.duration))
            ),
            backgroundColor: (workout is RealmWorkout)
                ? Color.realmWorkoutCellBackground
                : Color.firebaseWorkoutCellBackground
        )
    }

    private func process(with error: Error) {
        state.accept(.errorReceived((error as? LocalizedError)?.errorDescription ?? "Error"))
    }

}
