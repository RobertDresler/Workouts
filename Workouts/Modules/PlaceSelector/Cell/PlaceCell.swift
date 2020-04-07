//
//  PlaceCell.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit

final class PlaceCell: BCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 64

    func configure(for viewModel: PlaceCellViewModel) {
        textLabel?.attributedText = viewModel.title
    }

}
