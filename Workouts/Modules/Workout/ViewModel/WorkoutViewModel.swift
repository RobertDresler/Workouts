//
//  WorkoutViewModel.swift
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

final class WorkoutViewModel: BViewModel {

    var title: String {
        return R.string.localizable.workoutTitle()
    }

    enum State: Equatable {
        case initial
        case loading
        case saved
        case errorReceived(String)
    }

    typealias DataSourceItem = (model: Workout, viewModel: WorkoutCellViewModel)

    let bag = DisposeBag()
    let state = BehaviorRelay<State>(value: .initial)
    var dataSource = BehaviorRelay<[DataSourceItem]>(value: [])
    let isActivityIndicatorLoading = BehaviorRelay<Bool>(value: false)
    let isViewUserInteractionEnabled = BehaviorRelay<Bool>(value: true)
    let isSaveButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let isEverythingValid = BehaviorRelay<Bool>(value: false)
    var tempWorkout: TempWorkout? // TODO:  -RD- inject

    init() {
        // TODO: -RD- saver/repository
        setupBinding()
    }

    private func setupBinding() {
      /*  Observable.combineLatest(email, password)
            .map {
            }
            .bind(to: isEverythingValid)
            .disposed(by: bag)*/

        isEverythingValid.bind(to: isSaveButtonEnabled).disposed(by: bag)

        state.map { $0 == .loading }.bind(to: isActivityIndicatorLoading).disposed(by: bag)
        state.map { ![.loading, .saved].contains($0) }
            .bind(to: isViewUserInteractionEnabled)
            .disposed(by: bag)
    }

    func loadData() {
        dataSource.accept([])
    }

    func save() {
        guard isEverythingValid.value else { return }
    }

}
