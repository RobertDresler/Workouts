//
//  WorkoutPropertyDurationPickerCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class WorkoutPropertyDurationPickerCell: WorkoutPropertyCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 144

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        return datePicker
    }()

    override func addSubviews() {
        super.addSubviews()
        wrapperView.addSubview(datePicker)
    }

    override func setupConstraints() {
        super.setupConstraints()
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for viewModel: WorkoutPropertyDurationPickerCellViewModel) {
        datePicker.setDate(viewModel.date, animated: true)
        canBeHighlighted = viewModel.canBeHighlighted
    }

}
