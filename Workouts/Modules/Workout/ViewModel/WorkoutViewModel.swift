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

    var tempWorkout: TempWorkout {
        didSet {
            loadData()
        }
    }

    var repositoryType: RepositoryType = .realm

    private var titleItem: DataSourceItem {
        return .title(
            WorkoutPropertyTextFieldCellViewModel(
                title: tempWorkout.title,
                placeholder: R.string.localizable.workoutTitleItemPlaceholder(),
                isTextFieldEnabled: true
            )
        )
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
        let durationAsDate = Date(timeIntervalSince1970: tempWorkout.duration)
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

    init(tempWorkout: TempWorkout) {
        self.tempWorkout = tempWorkout
        // TODO: -RD- saver/repository
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
            WorkoutPropertyDurationPickerCellViewModel(countDownDuration: tempWorkout.duration)
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
        guard isEverythingValid.value else { return }
        // TODO: -RD- inject id before upload
    }

}
