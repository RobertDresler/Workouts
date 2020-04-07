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

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("\(String(describing: T.self)) is not registered for \(self)")
        }
        return cell
    }

}
