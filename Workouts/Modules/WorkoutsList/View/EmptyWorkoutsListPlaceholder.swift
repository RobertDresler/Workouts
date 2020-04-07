//
//  EmptyWorkoutsListPlaceholder.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit
import WorkoutsUI

final class EmptyWorkoutsListPlaceholder: BView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = R.string.localizable.emptyWorkoutsListPlaceholderTitle()
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = R.string.localizable.emptyWorkoutsListPlaceholderMessage()
        return label
    }()

    private lazy var contentStackView = [
        titleLabel, descriptionLabel
    ].stacked(.vertical, spacing: .huge)

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

}
