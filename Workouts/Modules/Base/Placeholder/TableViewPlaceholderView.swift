//
//  TableViewPlaceholderView.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class TableViewPlaceholderView: BView, Configurable {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var contentStackView = [
        titleLabel, descriptionLabel
    ].stacked(.vertical, spacing: .xxlarge)

    override func addSubviews() {
        super.addSubviews()
        addSubview(contentStackView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        contentStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(Padding.huge)
            make.bottom.lessThanOrEqualToSuperview().offset(-Padding.huge)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(readableContentGuide)
        }
    }

    func configure(for viewModel: TableViewPlaceholderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

}
