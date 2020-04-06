//
//  WorkoutPropertyDescriptionCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class WorkoutPropertyDescriptionCell: WorkoutPropertyCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 64

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .right
        return label
    }()

    private lazy var contentStackView = [
        titleLabel, descriptionLabel
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

    func configure(for viewModel: WorkoutPropertyDescriptionCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

}
