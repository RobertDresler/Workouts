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

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = R.string.localizable.emptyWorkoutsListPlaceholderTitle()
        return label
    }()

    override func addSubviews() {
        super.addSubviews()
        addSubview(textLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()
        textLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.huge)
            make.leading.trailing.equalTo(readableContentGuide)
        }
    }

}
