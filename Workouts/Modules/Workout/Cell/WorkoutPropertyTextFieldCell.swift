//
//  WorkoutPropertyTextFieldCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import UIKit
import WorkoutsUI

final class WorkoutPropertyTextFieldCell: WorkoutPropertyCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 64

    let textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    override func addSubviews() {
        super.addSubviews()
        wrapperView.addSubview(textField)
    }

    override func setupConstraints() {
        super.setupConstraints()
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for viewModel: WorkoutPropertyTextFieldCellViewModel) {
        textField.text = viewModel.title
        textField.sendActions(for: .editingChanged)
        textField.placeholder = viewModel.placeholder
        textField.isEnabled = viewModel.isTextFieldEnabled
        canBeHighlighted = viewModel.canBeHighlighted
    }

}
