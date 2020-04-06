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
import WorkoutsUI

final class WorkoutsListViewModel: BViewModel {

    var title: String {
        return R.string.localizable.workoutsListTitle()
    }

    enum State: Equatable {
        case initial
        case loading
        case loaded
    }

    typealias DataSourceItem = (model: Workout, viewModel: WorkoutCellViewModel)

    let bag = DisposeBag()
    let state = BehaviorRelay<State>(value: .initial)
    var dataSource = [DataSourceItem]()

    init() {}

    func loadData() {
        guard state.value != .loading else { return }
        state.accept(.loading)
        // TODO: -RD- real loading logic
        let models = (1...20).map { randomTestWorkout(with: $0) }
        dataSource = models.map { ($0, viewModel(for: $0)) }
        state.accept(.loaded)
    }

    private func randomTestWorkout(with id: Int) -> Workout {
        return Bool.random()
            ? RealmWorkout(id: id, title: "Realm Test")
            : FirebaseWorkout(id: id, title: "Firebase Test")
    }

    private func viewModel(for workout: Workout) -> WorkoutCellViewModel {
        return WorkoutCellViewModel(
            title: workout.title,
            backgroundColor: (workout is RealmWorkout)
                ? Color.realmWorkoutCellBackground
                : Color.firebaseWorkoutCellBackground
        )
    }

}
