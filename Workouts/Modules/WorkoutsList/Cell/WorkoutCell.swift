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

    private var normalBackgroundColor: UIColor?
    private var highlightedBackgroundColor: UIColor?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = Color.standardText
        return label
    }()

    private let placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Color.standardText
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Color.standardText
        return label
    }()

    private lazy var contentStackView = [
        titleLabel, placeLabel, durationLabel
    ].stacked(.vertical, spacing: .xsmall)

    private let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background
        view.layer.cornerRadius = CornerRadiusSize.large
        view.addShadow(color: Color.shadow, opacity: 0.15, radius: 12)
        return view
    }()

    override func setupView() {
        super.setupView()
        backgroundColor = Color.clear
    }

    override func addSubviews() {
        super.addSubviews()
        contentView.addSubviews(wrapperView)
        wrapperView.addSubviews(contentStackView)
    }

    override func setupSubviews() {
        super.setupSubviews()
        contentView.backgroundColor = Color.clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        wrapperView.backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
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
        placeLabel.text = viewModel.place
        durationLabel.text = viewModel.duration
        wrapperView.backgroundColor = viewModel.backgroundColor
        normalBackgroundColor = viewModel.backgroundColor
        highlightedBackgroundColor = viewModel.highlightedBackgroundColor
    }

}
