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
