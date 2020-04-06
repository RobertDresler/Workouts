//
//  UIView+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }

    func addGradient(with colors: [UIColor]) {
        guard layer.sublayers?.allSatisfy({ ($0 is CAGradientLayer) == false }) == true else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func addShadow(
        color: UIColor,
        opacity: Float,
        offset: CGSize = .zero,
        radius: CGFloat
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}
