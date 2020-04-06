//
//  WorkoutsListViewController.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

final class WorkoutsListViewController: BViewController<WorkoutsListViewModel, WorkoutsListContentView>,
    WorkoutsListView {

    weak var delegate: WorkoutsListViewDelegate?

    private var tableView: UITableView {
        return contentView.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.loadData()
    }

    private func setupTableView() {
        tableView.register(WorkoutCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = WorkoutCell.estimatedHeight
        viewModel.state.filter { $0 == .loaded }.bind { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: bag)
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
