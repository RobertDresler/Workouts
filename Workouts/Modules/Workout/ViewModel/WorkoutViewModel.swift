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
        switch usage {
        case .create:
            return R.string.localizable.createWorkoutTitle()
        case .edit:
            return R.string.localizable.editWorkoutTitle()
        }
    }

    enum State: Equatable {
        case initial
        case loading
        case saved
        case errorReceived(String)
    }

    enum DataSourceItem {
        case title(WorkoutPropertyTextFieldCellViewModel)
        case place(WorkoutPropertyTextFieldCellViewModel)
        case duration(WorkoutPropertyDescriptionCellViewModel)
        case durationPicker(WorkoutPropertyDurationPickerCellViewModel)
        case repository(WorkoutPropertyRepositoryCellViewModel)
    }

    let bag = DisposeBag()
    let state = BehaviorRelay<State>(value: .initial)
    var dataSource = [[DataSourceItem]]()

    let isActivityIndicatorLoading = BehaviorRelay<Bool>(value: false)
    let isViewUserInteractionEnabled = BehaviorRelay<Bool>(value: true)
    let isSaveButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let isEverythingValid = BehaviorRelay<Bool>(value: false)

    var tempWorkout: Workout {
        didSet {
            loadData()
        }
    }

    lazy var repositoryType: RepositoryType = (tempWorkout is FirebaseWorkout) ? .firebase : .realm

    var durationAsDate: Date {
        return Date(timeIntervalSince1970: tempWorkout.duration)
    }

    private var titleItem: DataSourceItem {
        return .title(
            WorkoutPropertyTextFieldCellViewModel(
                title: tempWorkout.title,
                placeholder: R.string.localizable.workoutTitleItemPlaceholder(),
                isTextFieldEnabled: true
            )
        )
    }

    var placeItemIndexPath: IndexPath? {
        var indexPath: IndexPath?
        dataSource.enumerated().forEach { sectionIndex, section in
            section.enumerated().forEach { rowIndex, item in
                guard case .place = item else { return }
                indexPath = IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return indexPath
    }

    private var placeItem: DataSourceItem {
        return .place(
            WorkoutPropertyTextFieldCellViewModel(
                title: tempWorkout.place,
                placeholder: R.string.localizable.workoutPlaceItemPlaceholder(),
                isTextFieldEnabled: false
            )
        )
    }

    var durationItemIndexPath: IndexPath? {
        var indexPath: IndexPath?
        dataSource.enumerated().forEach { sectionIndex, section in
            section.enumerated().forEach { rowIndex, item in
                guard case .duration = item else { return }
                indexPath = IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return indexPath
    }

    private var durationItem: DataSourceItem {
        return .duration(
            WorkoutPropertyDescriptionCellViewModel(
                title: R.string.localizable.workoutDurationItemTitle(),
                description: "\(DateFormatter.HmmInterval.string(from: durationAsDate))"
            )
        )
    }

    var durationPickerItemIndexPath: IndexPath? {
        var indexPath: IndexPath?
        dataSource.enumerated().forEach { sectionIndex, section in
            section.enumerated().forEach { rowIndex, item in
                guard case .durationPicker = item else { return }
                indexPath = IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return indexPath
    }

    private var durationPickerItem: DataSourceItem?

    private var repositoryTypeItem: DataSourceItem {
        return .repository(
            WorkoutPropertyRepositoryCellViewModel(repositoryType: repositoryType)
        )
    }

    private let saver: WorkoutsSaver
    private let updater: WorkoutsUpdater
    private let deleter: WorkoutsDeleter
    private let usage: WorkoutViewUsage

    init(
        tempWorkout: Workout,
        saver: WorkoutsSaver,
        updater: WorkoutsUpdater,
        deleter: WorkoutsDeleter,
        usage: WorkoutViewUsage
    ) {
        self.tempWorkout = tempWorkout
        self.saver = saver
        self.updater = updater
        self.deleter = deleter
        self.usage = usage
        setupBinding()
    }

    private func setupBinding() {
        isEverythingValid.bind(to: isSaveButtonEnabled).disposed(by: bag)

        state.map { $0 == .loading }.bind(to: isActivityIndicatorLoading).disposed(by: bag)
        state.map { ![.loading, .saved].contains($0) }
            .bind(to: isViewUserInteractionEnabled)
            .disposed(by: bag)
    }

    func toogleDurationPickerItem() {
        durationPickerItem = durationPickerItem == nil ? makeDurationPickerItem() : nil
        loadData()
    }

    private func makeDurationPickerItem() -> DataSourceItem {
        return .durationPicker(
            WorkoutPropertyDurationPickerCellViewModel(date: durationAsDate)
        )
    }

    func loadData() {
        dataSource = [
            [
                titleItem,
                placeItem
            ],
            [
                durationItem,
                durationPickerItem
            ].compactMap { $0 },
            [
                repositoryTypeItem
            ]
        ]
        setupIsEverythingValid()
    }

    private func setupIsEverythingValid() {
        let isEverythingValid =
            !tempWorkout.title.isEmpty
            && !tempWorkout.place.isEmpty
            && tempWorkout.duration > 0
        self.isEverythingValid.accept(isEverythingValid)
    }

    func save() {
        guard isEverythingValid.value, ![.loading, .saved].contains(state.value) else { return }
        state.accept(.loading)

        switch usage {
        case .create:
            saveCreatedWorkout()
        case .edit(let workout):
            saveEditedWorkout(workout)
        }
    }

    private func saveCreatedWorkout() {
        saver.save(tempWorkout, to: repositoryType).subscribe(
            onSuccess: { [weak self] in self?.processSuccess() },
            onError: { [weak self] in self?.process(with: $0) }
        ).disposed(by: bag)
    }

    private func saveEditedWorkout(_ workout: Workout) {
        if workout is RealmWorkout && repositoryType == .realm {
            updateTempWorkout(in: .realm)

        } else if workout is FirebaseWorkout && repositoryType == .firebase {
            updateTempWorkout(in: .firebase)

        } else if workout is RealmWorkout && repositoryType == .firebase {
            deleter.delete(tempWorkout, from: .realm).subscribe(
                onSuccess: { [weak self] in self?.saveTempWorkoutAfterDeletion(to: .firebase) },
                onError: { [weak self] in self?.process(with: $0) }
            ).disposed(by: bag)

        } else {
            deleter.delete(tempWorkout, from: .firebase).subscribe(
                onSuccess: { [weak self] in self?.saveTempWorkoutAfterDeletion(to: .realm) },
                onError: { [weak self] in self?.process(with: $0) }
            ).disposed(by: bag)
        }
    }

    private func updateTempWorkout(in repositoryType: RepositoryType) {
        updater.update(tempWorkout, in: repositoryType).subscribe(
            onSuccess: { [weak self] in self?.processSuccess() },
            onError: { [weak self] in self?.process(with: $0) }
        ).disposed(by: self.bag)
    }

    private func saveTempWorkoutAfterDeletion(to repositoryType: RepositoryType) {
        saver.save(tempWorkout, to: repositoryType).subscribe(
            onSuccess: { [weak self] in self?.processSuccess() },
            onError: { [weak self] in self?.process(with: $0) }
        ).disposed(by: self.bag)
    }

    private func processSuccess() {
        state.accept(.saved)
    }

    private func process(with error: Error) {
        state.accept(.errorReceived((error as? LocalizedError)?.errorDescription ?? "Error"))
    }

}
