//
//  WorkoutCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class WorkoutCell: BCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 128

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Color.standardText
        return label
    }()

    private lazy var contentStackView = [
        titleLabel
    ].stacked(.vertical, spacing: .large)

    private let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background
        view.layer.cornerRadius = CornerRadiusSize.large
        view.addShadow(color: Color.shadow, opacity: 0.15, radius: 12)
        return view
    }()

    override func setupView() {
        super.setupView()
        backgroundColor = .clear
    }

    override func addSubviews() {
        super.addSubviews()
        contentView.addSubviews(wrapperView)
        wrapperView.addSubviews(contentStackView)
    }

    override func setupSubviews() {
        super.setupSubviews()
        contentView.backgroundColor = .clear
    }

    override func setupConstraints() {
        super.setupConstraints()
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.small)
            make.leading.trailing.equalTo(readableContentGuide)
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Padding.large)
        }
    }

    func configure(for viewModel: WorkoutCellViewModel) {
        titleLabel.text = viewModel.title
        wrapperView.backgroundColor = viewModel.backgroundColor
    }

}
