//
//  WorkoutPropertyDurationPickerCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift
import UIKit
import WorkoutsUI

final class WorkoutPropertyDurationPickerCell: BCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 144

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        return datePicker
    }()

    var bag = DisposeBag()

    private let wrapperView = UIView()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(datePicker)
    }

    override func setupSubviews() {
        super.setupSubviews()
        contentView.backgroundColor = Color.cellBackground
    }

    override func setupConstraints() {
        super.setupConstraints()
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.large)
            make.leading.trailing.equalTo(readableContentGuide)
        }
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for viewModel: WorkoutPropertyDurationPickerCellViewModel) {
        datePicker.countDownDuration = viewModel.countDownDuration
    }

}
