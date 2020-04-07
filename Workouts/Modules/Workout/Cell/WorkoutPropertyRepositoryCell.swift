//
//  WorkoutPropertyRepositoryCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class WorkoutPropertyRepositoryCell: WorkoutPropertyCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 64

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.workoutRepositoryTypeItemTitle()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    let segmentedControl = UISegmentedControl(items: RepositoryType.allCases.map { $0.title })

    private lazy var contentStackView = [
        titleLabel, segmentedControl
    ].stacked(.horizontal, spacing: .large)

    override func addSubviews() {
        super.addSubviews()
        wrapperView.addSubview(contentStackView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for viewModel: WorkoutPropertyRepositoryCellViewModel) {
        segmentedControl.selectedSegmentIndex = viewModel.repositoryType.rawValue
        canBeHighlighted = viewModel.canBeHighlighted
    }

}
