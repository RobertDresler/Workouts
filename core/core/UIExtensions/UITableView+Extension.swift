//
//  UITableView+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public extension UITableView {

    func register(_ cellTypes: UITableViewCell.Type...) {
        cellTypes.forEach { register($0, forCellReuseIdentifier: String(describing: $0.self)) }
    }

    func registerHeaderFooterViews(_ viewTypes: UIView.Type...) {
        viewTypes.forEach { register($0, forHeaderFooterViewReuseIdentifier: String(describing: $0.self)) }
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("\(String(describing: T.self)) is not registered for \(self)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: T.self)
        ) as? T else {
            fatalError("\(String(describing: T.self)) is not registered for \(self)")
        }
        return view
    }

    func setHeaderView(_ view: UIView) {
        view.frame = bounds

        view.setNeedsLayout()
        view.layoutIfNeeded()

        let height = view.systemLayoutSizeFitting(
            CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        ).height
        var frame = view.frame
        frame.size.height = height
        view.frame = frame

        tableHeaderView = view

        sectionHeaderHeight = 0
    }

    func setFooterView(_ view: UIView) {
        view.frame = bounds

        view.setNeedsLayout()
        view.layoutIfNeeded()

        let height = view.systemLayoutSizeFitting(
            CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        ).height
        var frame = view.frame
        frame.size.height = height
        view.frame = frame

        tableFooterView = view

        sectionFooterHeight = 0
    }

    func isRowPresent(for indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard isRowPresent(for: indexPath) else { return }
        scrollToRow(at: indexPath, at: .top, animated: true)
    }

}
