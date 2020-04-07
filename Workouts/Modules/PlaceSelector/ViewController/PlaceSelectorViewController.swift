//
//  PlaceSelectorViewController.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import MapKit
import UIKit

final class PlaceSelectorViewController: BViewController<PlaceSelectorViewModel, PlaceSelectorContentView>,
    PlaceSelectorView {

    weak var delegate: PlaceSelectorViewDelegate?

    private var searchController = UISearchController()

    private var tableView: UITableView {
        return contentView.tableView
    }

    deinit {
        delegate?.placeSelectorViewWillBeDeinitialized()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addCancelBarButtonItem()
        setupTableView()
        setupSearchController()
    }

    private func setupTableView() {
        tableView.register(PlaceCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = PlaceCell.estimatedHeight
        viewModel.dataSource.bind { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: bag)
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
        delegate?.placeSelectorViewDidTapCancelButton()
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        searchController.searchResultsUpdater = viewModel
        tableView.tableHeaderView = searchController.searchBar
    }

}

extension PlaceSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel.dataSource.value[safe: indexPath.row]?.viewModel else {
            fatalError("Bad manipulating with data source.")
        }
        let cell: PlaceCell = tableView.dequeueReusableCell(for: indexPath)
        return cell.configured(for: viewModel)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.dataSource.value[safe: indexPath.row]?.model else {
            fatalError("Bad manipulating with data source.")
        }
        delegate?.didSelectPlace(model.title)
    }
}
