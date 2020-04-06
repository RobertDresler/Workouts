//
//  Array+UIView+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit
import WorkoutsUI

public extension Array where Element: UIView {
    func stacked(
        _ axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: Spacing = .zero
    ) -> UIStackView {

        let view = UIStackView(arrangedSubviews: self)

        view.axis = axis
        view.distribution = distribution
        view.alignment = alignment
        view.spacing = spacing

        return view
    }
}
