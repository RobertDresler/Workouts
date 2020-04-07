//
//  WorkoutsListViewController.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import Toast_Swift
import UIKit

final class WorkoutsListViewController: BViewController<WorkoutsListViewModel, WorkoutsListContentView>,
    WorkoutsListView {

    weak var delegate: WorkoutsListViewDelegate?

    private lazy var modeBarButtonItem = UIBarButtonItem(
        title: viewModel.modeBarButtonTitle,
        style: .plain,
        target: self,
        action: #selector(modeBarButtonItemPressed)
    )

    private let placeholderView = TableViewPlaceholderView()

    private var tableView: UITableView {
        return contentView.tableView
    }

    func loadData() {
        viewModel.loadData()
    }

    func deleteWorkout(_ workout: Workout) {
        viewModel.deleteWorkout(workout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addBarButtonItems()
        viewModel.loadData()
    }

    override func bindViewModel() {
        super.bindViewModel()
        viewModel.isActivityIndicatorLoading
            .bind { [weak self] isLoading in
                if isLoading && self?.tableView.refreshControl?.isRefreshing == false {
                    self?.view.makeToastActivity(.center)
                } else {
                    self?.view.hideToastActivity()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .disposed(by: bag)

        viewModel.placeholderViewModel.bind { [weak self] viewModel in
            if let viewModel = viewModel {
                self?.placeholderView.configure(for: viewModel)
                self?.tableView.backgroundView = self?.placeholderView
            } else {
                self?.tableView.backgroundView = nil
            }
        }.disposed(by: bag)

        viewModel.isModeBarButtonItemEnabled.bind(to: modeBarButtonItem.rx.isEnabled).disposed(by: bag)
    }

    private func setupTableView() {
        tableView.register(WorkoutCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        tableView.estimatedRowHeight = WorkoutCell.estimatedHeight
        viewModel.state.filter { $0 == .loaded }.bind { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: bag)
    }

    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshControlChanged() {
        viewModel.loadData()
    }

    private func addBarButtonItems() {
        addModeBarButtonItem()
        addNewWorkoutBarButtonItem()
    }

    private func addModeBarButtonItem() {
        let item = UIBarButtonItem(
            title: viewModel.modeBarButtonTitle,
            style: .plain,
            target: self,
            action: #selector(modeBarButtonItemPressed)
        )
        navigationItem.leftBarButtonItem = item
    }

    @objc private func modeBarButtonItemPressed() {
        viewModel.changeMode()
        setupModeBarButtonItemTitle()
    }

    private func setupModeBarButtonItemTitle() {
        navigationItem.leftBarButtonItem?.title = viewModel.modeBarButtonTitle
    }

    private func addNewWorkoutBarButtonItem() {
        let item = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(newWorkoutBarButtonItemPressed)
        )
        navigationItem.rightBarButtonItem = item
    }

    @objc private func newWorkoutBarButtonItemPressed() {
        delegate?.newWorkoutButtonPressed()
    }

}

extension WorkoutsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel.dataSource[safe: indexPath.row]?.viewModel else {
            fatalError("Bad manipulating with data source.")
        }
        let cell: WorkoutCell = tableView.dequeueReusableCell(for: indexPath)
        return cell.configured(for: viewModel)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.viewModel.dataSource[safe: indexPath.row]?.model else {
            return assertionFailure("Bad manipulating with data source.")
        }
        delegate?.didSelectWorkout(model)
    }
}
