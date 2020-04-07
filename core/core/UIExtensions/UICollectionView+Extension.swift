//
//  UICollectionView+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public extension UICollectionView {

    func register(_ cellTypes: UICollectionViewCell.Type...) {
        cellTypes.forEach { register($0, forCellWithReuseIdentifier: String(describing: $0)) }
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: Cell.self),
            for: indexPath
        ) as? Cell else {
            fatalError("\(String(describing: Cell.self)) is not registered for \(self)")
        }
        return cell
    }

}
