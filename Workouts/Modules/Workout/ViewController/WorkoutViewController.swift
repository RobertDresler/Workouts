//
//  WorkoutViewController.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import Toast_Swift
import UIKit

final class WorkoutViewController: BViewController<WorkoutViewModel, WorkoutContentView>,
    WorkoutView {

    weak var delegate: WorkoutViewDelegate?

    private let saveButtonItem = UIBarButtonItem(
        barButtonSystemItem: .save,
        target: self,
        action: #selector(saveBarButtonItemPressed)
    )

    private var tableView: UITableView {
        return contentView.tableView
    }

    deinit {
        delegate?.workoutViewWillBeDeinitialized()
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
            .bind { [weak self] in $0 ? self?.view.makeToastActivity(.center) : self?.view.hideToastActivity() }
            .disposed(by: bag)

        viewModel.isViewUserInteractionEnabled.bind(to: contentView.rx.isUserInteractionEnabled).disposed(by: bag)
        viewModel.isSaveButtonEnabled
            .bind(to: saveButtonItem.rx.isEnabled)
            .disposed(by: bag)

        viewModel.state.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .saved:
                self.delegate?.didSaveWorkout()
            case .errorReceived(let message):
                self.view.makeToast(message)
            default:
                break
            }
        }.disposed(by: bag)

        viewModel.isActivityIndicatorLoading
            .bind { [weak self] in $0 ? self?.view.makeToastActivity(.center) : self?.view.hideToastActivity() }
            .disposed(by: bag)
    }

    private func setupTableView() {
        tableView.register(WorkoutCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = WorkoutCell.estimatedHeight
        viewModel.dataSource.bind { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: bag)
    }

    private func addBarButtonItems() {
        addCancelBarButtonItem()
        addSaveWorkoutBarButtonItem()
    }

    private func addCancelBarButtonItem() {
        let item = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelBarButtonItemPressed)
        )
        navigationItem.leftBarButtonItem = item
    }

    @objc private func cancelBarButtonItemPressed() {
        delegate?.workoutViewDidTapCancelButton()
    }

    private func addSaveWorkoutBarButtonItem() {
        navigationItem.rightBarButtonItem = saveButtonItem
    }

    @objc private func saveBarButtonItemPressed() {
        // TODO: -RD- save
    }

}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // TODO: -RD- implement
        //return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: -RD- implement
        fatalError()
    }
        /*guard let viewModel = self.viewModel.dataSource[safe: indexPath.row]?.viewModel else {
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
    }*/
}
