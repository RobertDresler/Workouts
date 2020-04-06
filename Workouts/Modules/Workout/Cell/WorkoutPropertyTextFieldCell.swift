//
//  WorkoutPropertyTextFieldCell.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift
import UIKit
import WorkoutsUI

final class WorkoutPropertyTextFieldCell: BCell, Configurable, DynamicHeightView {

    static var estimatedHeight: CGFloat = 64

    let textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        return textField
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
        wrapperView.addSubview(textField)
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
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for viewModel: WorkoutPropertyTextFieldCellViewModel) {
        textField.text = viewModel.title
        textField.placeholder = viewModel.placeholder
        textField.isEnabled = viewModel.isTextFieldEnabled
    }

}
