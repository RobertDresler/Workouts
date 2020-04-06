//
//  WorkoutsListContentView.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import SnapKit
import UIKit
import WorkoutsUI

final class WorkoutsListContentView: BView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset.bottom = Padding.xxhuge
        return tableView
    }()

    override func setupView() {
        super.setupView()
        backgroundColor = Color.background
    }

    override func addSubviews() {
        super.addSubviews()
        addSubviews(tableView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}
