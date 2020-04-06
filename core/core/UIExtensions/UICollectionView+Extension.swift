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

    func registerHeaders(_ headerTypes: UICollectionReusableView.Type...) {
        headerTypes.forEach {
            register(
                $0,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: $0)
            )
        }
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

    func dequeueReusableHeader<HeaderView: UICollectionReusableView>(for indexPath: IndexPath) -> HeaderView {
        guard let headerView = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: HeaderView.self),
            for: indexPath
        ) as? HeaderView else {
            fatalError("\(String(describing: HeaderView.self)) is not registered for this collection view.")
        }
        return headerView
    }

}
